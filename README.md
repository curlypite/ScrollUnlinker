# ScrollUnlinker
A lightweight macOS utility to decouple mouse and trackpad scroll directions.
# 🖱️ ScrollUnlinker for macOS

A lightweight, background utility for macOS that finally decouples your trackpad and physical mouse scroll directions.

If you use a trackpad and a traditional scroll-wheel mouse on the same Mac, you've likely encountered Apple's infamous limitation: the "Natural Scrolling" setting is linked. If you fix the trackpad, the mouse scrolls backward. If you fix the mouse, the trackpad scrolls backward.

**ScrollUnlinker** solves this by intercepting physical mouse inputs and silently reversing them, allowing you to keep "Natural Scrolling" turned ON for your trackpad, while retaining classic scrolling for your mouse.

## ✨ Features
* **Zero Configuration:** Just run it and it works.
* **Menu Bar Integration:** Sits quietly in your menu bar.
* **Launch at Login:** Toggle automatic startup with a single click.
* **Resource Friendly:** Extremely lightweight and uses minimal memory.

## 🚀 Installation & Setup
1. Download the latest `ScrollUnlinker.zip` from the **[Releases](../../releases)** page.
2. Unzip the file and drag the `ScrollUnlinker` app into your **Applications** folder.
3. Open your Mac's **System Settings**.
4. Navigate to **Trackpad** (or Mouse) and ensure **Natural scrolling** is turned **ON**. 
5. Double-click the `ScrollUnlinker` app to launch it.

### 🔐 Accessibility Permissions
Because this app intercepts system-wide scrolling events, macOS will require you to grant it Accessibility permissions on its first launch.
1. When prompted, click **Open System Settings**.
2. Find `ScrollUnlinker` in the list and turn the toggle **ON**.
3. *Note: If the app does not appear in the list, manually navigate to System Settings -> Privacy & Security -> Accessibility and add it.*
4. Restart the app.

## 🛠️ How it Works Under the Hood
ScrollUnlinker uses a `CGEventTap` to monitor `scrollWheel` events. It checks the `kCGScrollWheelEventIsContinuous` flag to distinguish between smooth trackpad swipes (continuous) and physical mouse wheel clicks (discrete). If it detects a discrete mouse wheel click, it dynamically inverts the Y-axis delta before passing it back to macOS.
