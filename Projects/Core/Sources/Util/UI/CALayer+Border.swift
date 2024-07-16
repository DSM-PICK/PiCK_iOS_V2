import UIKit

public extension CALayer {
    func border(color: UIColor?, width: CGFloat?) {
        self.borderColor = color?.cgColor
        self.borderWidth = width ?? CGFloat()
    }
}
