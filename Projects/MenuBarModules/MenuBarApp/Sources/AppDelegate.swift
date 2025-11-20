import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var mealViewController: MealViewController!
    var popover: NSPopover!

    func applicationDidFinishLaunching(_ notification: Notification) {
        setupMenuBarIcon()
    }

    private func setupMenuBarIcon() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

        guard let button = statusItem.button else { return }

        if let icon = NSImage(systemSymbolName: "fork.knife", accessibilityDescription: "Meal Menu") {
            icon.isTemplate = true
            button.image = icon
        } else {
            button.title = "🍽"
        }

        button.target = self
        button.action = #selector(togglePopover)

        popover = NSPopover()
        popover.contentSize = NSSize(width: 400, height: 500)
        popover.behavior = .transient

        mealViewController = MealViewController()
        popover.contentViewController = mealViewController
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
