import UIKit

public extension CALayer {
    func border(color: UIColor?, width: CGFloat = 0) {
        self.borderColor = color?.cgColor
        self.borderWidth = width
    }

    func addDotBorder(color: UIColor, lineWidth: CGFloat, dotRadius: CGFloat) {

        self.sublayers?.removeAll(where: { $0.name == "DotBorder" })

        let dotBorder = CAShapeLayer()
        dotBorder.name = "DotBorder"
        dotBorder.strokeColor = color.cgColor
        dotBorder.fillColor = nil
        dotBorder.lineWidth = lineWidth
        dotBorder.lineDashPattern = [NSNumber(value: Double(dotRadius)), NSNumber(value: Double(dotRadius * 2))]

        dotBorder.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.cornerRadius).cgPath

        self.addSublayer(dotBorder)
    }

    func addshadow(
        color: UIColor,
        alpha: Float,
        x: CGFloat,
        y: CGFloat,
        blur: CGFloat,
        spread: CGFloat
    ) {
        masksToBounds = false
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / UIScreen.main.scale
        if spread == 0 {
            shadowPath = nil
        } else {
            let rect = bounds.insetBy(dx: -spread, dy: -spread)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }

}
