import Cocoa

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate

app.setActivationPolicy(.prohibited)

print("🔧 App activation policy set to .prohibited")

app.run()
