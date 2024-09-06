import UIKit

import Core
import DesignSystem

public class ClassroomSegmentedControl: UISegmentedControl {
    private lazy var underlineView: UIView = {
        let width = self.bounds.size.width / CGFloat(self.numberOfSegments)
        let height = 1.0
        let xPosition = CGFloat(self.selectedSegmentIndex * Int(width))
        let yPosition = self.bounds.size.height - 1.0
        let frame = CGRect(x: xPosition, y: yPosition, width: width, height: height)
        let view = UIView(frame: frame)
        view.backgroundColor = .main400
        self.addSubview(view)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.removeBackgroundAndDivider()
    }
    override init(items: [Any]?) {
        super.init(items: items)
        self.removeBackgroundAndDivider()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func removeBackgroundAndDivider() {
        let image = UIImage()
        self.setBackgroundImage(image, for: .normal, barMetrics: .default)
        self.setBackgroundImage(image, for: .selected, barMetrics: .default)
        self.setBackgroundImage(image, for: .highlighted, barMetrics: .default)
        
        self.setDividerImage(image, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()

        setuptTextAttributes()
        setupAction()
    }

    private func setupAction() {
        let underlineFinalXPosition = (self.bounds.width / CGFloat(self.numberOfSegments)) * CGFloat(self.selectedSegmentIndex)
        UIView.animate(
            withDuration: 0.25,
            animations: {
                self.underlineView.frame.origin.x = underlineFinalXPosition
            }
        )

    }
    private func setuptTextAttributes() {
        self.setTitleTextAttributes(
            [
                NSAttributedString.Key.foregroundColor: UIColor.gray500,
                    .font: UIFont.body1
            ],
            for: .normal
        )
        self.setTitleTextAttributes(
            [
              NSAttributedString.Key.foregroundColor: UIColor.modeBlack
            ],
            for: .selected
          )
    }

}
