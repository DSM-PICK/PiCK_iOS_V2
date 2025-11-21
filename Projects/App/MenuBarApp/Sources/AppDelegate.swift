import Cocoa
import MenuBarNetwork

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var mealViewController: MealViewController!
    var loginViewController: LoginViewController!
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
        popover.behavior = .transient

        updateContentViewController()
    }

    private func updateContentViewController() {
        if isLoggedIn() {
            mealViewController = MealViewController()
            popover.contentSize = NSSize(width: 400, height: 500)
            popover.contentViewController = mealViewController
        } else {
            loginViewController = LoginViewController()
            loginViewController.onLoginSuccess = { [weak self] in
                self?.updateContentViewController()
            }
            popover.contentSize = NSSize(width: 300, height: 200)
            popover.contentViewController = loginViewController
        }
    }

    private func isLoggedIn() -> Bool {
        let token = JwtStore.shared.accessToken ?? ""
        return !token.isEmpty && token != "Failed To Load Keychain Value"
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
