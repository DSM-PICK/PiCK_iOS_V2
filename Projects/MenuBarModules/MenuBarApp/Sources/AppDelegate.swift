import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var mealViewController: MealViewController!
    var popover: NSPopover!

    func applicationDidFinishLaunching(_ notification: Notification) {
        UserDefaults.standard.removeObject(forKey: "NSStatusItem Visible MenuBarApp")
        UserDefaults.standard.synchronize()

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        objc_setAssociatedObject(NSApp, "statusItem", statusItem, .OBJC_ASSOCIATION_RETAIN)

        if let button = statusItem.button {
            if let icon = NSImage(systemSymbolName: "fork.knife", accessibilityDescription: "Meal Menu") {
                icon.isTemplate = true
                button.image = icon
            } else {
                button.title = "🍽"
            }

            button.wantsLayer = true
            button.layer?.backgroundColor = NSColor.systemRed.withAlphaComponent(0.3).cgColor
            button.layer?.cornerRadius = 4

            button.target = self
            button.action = #selector(togglePopover)

            button.window?.level = .statusBar
            button.window?.makeKeyAndOrderFront(nil)
        }

        popover = NSPopover()
        popover.contentSize = NSSize(width: 400, height: 500)
        popover.behavior = .transient

        mealViewController = MealViewController()
        popover.contentViewController = mealViewController

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            if let item = self.statusItem {
                item.isVisible = true
                item.button?.needsDisplay = true
            }
        }
    }

    @objc func togglePopover() {
        if let button = statusItem.button {
            if popover.isShown {
                popover.performClose(nil)
            } else {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            }
        }
    }
}
