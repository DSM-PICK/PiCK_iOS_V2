import UIKit

public extension UIViewController {
    func presentAsCustomDents(view: UIViewController, height: CGFloat) {
        let customDetents = UISheetPresentationController.Detent.custom(
            identifier: .init("sheetHeight")
        ) { _ in
            return height
        }

        if let sheet = view.sheetPresentationController {
            sheet.detents = [customDetents]
        }
        self.present(view, animated: true)
    }

}
