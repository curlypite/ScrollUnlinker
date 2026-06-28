import SwiftUI
import CoreGraphics
import ApplicationServices

class ScrollController {
    private var eventTap: CFMachPort?

    func startTracking() {
        // 1. Ask macOS for permission to look at mouse movements
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true] as CFDictionary
        let isTrusted = AXIsProcessTrustedWithOptions(options)
        

        // 2. Catch scroll wheel actions
        let eventMask = (1 << CGEventType.scrollWheel.rawValue)

        eventTap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: CGEventMask(eventMask),
            callback: { (proxy, type, event, refcon) -> Unmanaged<CGEvent>? in
                
                if type == .scrollWheel {
                    // Is it a smooth trackpad (1) or a clicky mouse wheel (0)?
                    let isContinuous = event.getIntegerValueField(.scrollWheelEventIsContinuous)
                    
                    if isContinuous == 0 {
                        // It's a regular mouse! Reverse the vertical scroll direction
                        let deltaY = event.getIntegerValueField(.scrollWheelEventDeltaAxis1)
                        let fixedDeltaY = event.getIntegerValueField(.scrollWheelEventFixedPtDeltaAxis1) // Fixed here
                        
                        event.setIntegerValueField(.scrollWheelEventDeltaAxis1, value: -deltaY)
                        event.setIntegerValueField(.scrollWheelEventFixedPtDeltaAxis1, value: -fixedDeltaY) // Fixed here
                    }
                }
                return Unmanaged.passRetained(event)
            },
            userInfo: nil
        )

        guard let eventTap = eventTap else { return }

        // 3. Keep the logic running silently in the background
        let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: eventTap, enable: true)
    }
}

@main
struct ScrollUnlinkerApp: App {
    let controller = ScrollController()
    
    init() {
        controller.startTracking()
    }
    
    var body: some Scene {
        // Keeps the app window completely invisible
        Settings {
            EmptyView()
        }
    }
}



