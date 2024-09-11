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

}
