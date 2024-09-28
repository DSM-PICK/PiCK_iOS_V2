import UIKit

public extension UITextField {
    func addLeftView() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }

    func addRightView() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: self.frame.height))
        self.rightView = paddingView
        self.rightViewMode = ViewMode.always
    }

    func addLeftAndRightView() {
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: self.frame.height))
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 34, height: self.frame.height))
        self.leftView = leftPaddingView
        self.leftViewMode = ViewMode.always
        self.rightView = rightPaddingView
        self.rightViewMode = ViewMode.always
    }
}
