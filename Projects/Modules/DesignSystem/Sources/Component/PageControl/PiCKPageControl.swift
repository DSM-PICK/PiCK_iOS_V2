import UIKit

public class PiCKPageControl: UIPageControl {
    private var selectedIndex: Int = 0
    private var remainingDecimal: CGFloat = 0
    private var selectedColor: UIColor = .clear {
        didSet {
            reset()
        }
    }
    private var unselectedColor: UIColor = .clear {
        didSet {
            reset()
        }
    }

    public var dotRadius: CGFloat = 4 {
        didSet {
            reset()
        }
    }
    public var dotSpacings: CGFloat = 8 {
        didSet {
            reset()
        }
    }
    public override var numberOfPages: Int {
        didSet {
            reset()
        }
    }

    public override var currentPage: Int {
        didSet {
            reset()
        }
    }
    public override var pageIndicatorTintColor: UIColor? {
        set {
            unselectedColor = newValue ?? .clear
        }
        get {
            .clear
        }
    }
    public override var currentPageIndicatorTintColor: UIColor? {
        set {
            selectedColor = newValue ?? .clear
        }
        get {
            return .clear
        }
    }

    public override func draw(_ rect: CGRect) {
        guard numberOfPages > 0 else { return }
        for index in 0 ... numberOfPages {
            guard index != selectedIndex + 1 else { continue }
            let previousCirclesX = CGFloat(index) * (dotSpacings + (dotRadius * 2))
            var percentageWidth: CGFloat = 0
            var originX: CGFloat = previousCirclesX
            var barColor: UIColor = selectedColor
            switch index {
                case selectedIndex:
                    percentageWidth = dotRadius * 2 + ((dotRadius * 2 + dotSpacings) * (1 - self.remainingDecimal))
                    barColor = between(selectedColor, and: unselectedColor, percentage: remainingDecimal)
                case selectedIndex + 2:
                    percentageWidth = dotRadius * 2 + ((dotRadius * 2 + dotSpacings) * (self.remainingDecimal))
                    originX = previousCirclesX - percentageWidth + dotRadius * 2
                    barColor = between(unselectedColor, and: selectedColor, percentage: remainingDecimal)
                default:
                    percentageWidth = dotRadius * 2
                    barColor = unselectedColor
            }
            barColor.setFill()
            let bezierPath = UIBezierPath(roundedRect: .init(
                x: originX,
                y: 0,
                width: percentageWidth,
                height: dotRadius * 2
            ), cornerRadius: dotRadius)
            bezierPath.fill()
        }
    }

    public override var intrinsicContentSize: CGSize {
        let spacesWidth = CGFloat(numberOfPages) * dotSpacings
        let dotsWidth = CGFloat(numberOfPages + 1) * (dotRadius * 2)
        return .init(width: spacesWidth + dotsWidth, height: dotRadius * 2)
    }

    public func setOffset(_ offset: CGFloat, width: CGFloat) {
        selectedIndex = Int(offset / width)
        remainingDecimal = offset / width - CGFloat(selectedIndex)
        setNeedsDisplay()
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.setOffset(scrollView.contentOffset.x, width: scrollView.bounds.width)
    }

    public func scrollViewDidScrollAtMain(_ scrollView: UIScrollView) {
        self.setOffset(scrollView.contentOffset.x, width: scrollView.bounds.width - 48)
    }

    private func reset() {
        self.invalidateIntrinsicContentSize()
        self.setNeedsDisplay()
    }

    private func between(_ color1: UIColor, and color2: UIColor, percentage: CGFloat) -> UIColor {
        let percentage = max(min(percentage, 100), 0)
        switch percentage {
        case 0: return color1
        case 1: return color2
        default:
            var (red1, red2): (CGFloat, CGFloat) = (0, 0)
            var (green1, green2): (CGFloat, CGFloat) = (0, 0)
            var (blue1, blue2): (CGFloat, CGFloat) = (0, 0)
            var (alpha1, alpha2): (CGFloat, CGFloat) = (0, 0)
            guard color1.getRed(&red1, green: &green1, blue: &blue1, alpha: &alpha1) else { return color1 }
            guard color2.getRed(&red2, green: &green2, blue: &blue2, alpha: &alpha2) else { return color2 }
            return UIColor(
                red: CGFloat(red1 + (red2 - red1) * percentage),
                green: CGFloat(green1 + (green2 - green1) * percentage),
                blue: CGFloat(blue1 + (blue2 - blue1) * percentage),
                alpha: CGFloat(alpha1 + (alpha2 - alpha1) * percentage))
        }
    }
}
