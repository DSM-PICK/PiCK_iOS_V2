import UIKit

import Core
import DesignSystem

public class ClassroomSegmentedControl: UISegmentedControl {
    private lazy var underlineView: UIView = {
        let width = self.bounds.size.width / 5
        let height = 2.0
        let xPosition = CGFloat(self.selectedSegmentIndex) * width
        let yPosition = self.bounds.size.height - height
        let frame = CGRect(x: xPosition, y: yPosition, width: width, height: height)
        let view = UIView(frame: frame)
        view.backgroundColor = .main400
        self.addSubview(view)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.removeBackgroundAndDivider()
        self.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }

    override init(items: [Any]?) {
        super.init(items: items)
        self.removeBackgroundAndDivider()
        self.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
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

        let underlineHeight: CGFloat = 2.0
        let underlineWidth = self.bounds.width / 5

        underlineView.frame.size.width = underlineWidth
        underlineView.frame.size.height = underlineHeight
        underlineView.frame.origin.y = self.bounds.height - underlineHeight

        updateUnderlinePosition(animated: false)
    }

    @objc private func segmentChanged() {
        updateUnderlinePosition(animated: true)
    }

    public override var selectedSegmentIndex: Int {
        didSet {
            if oldValue != selectedSegmentIndex {
                updateUnderlinePosition(animated: true)
            }
        }
    }

    private func updateUnderlinePosition(animated: Bool) {
        guard self.numberOfSegments > 0 else { return }

        let underlineWidth = self.bounds.width / CGFloat(self.numberOfSegments)
        let underlineFinalXPosition = underlineWidth * CGFloat(self.selectedSegmentIndex)

        if animated {
            UIView.animate(withDuration: 0.25) {
                self.underlineView.frame.origin.x = underlineFinalXPosition
            }
        } else {
            self.underlineView.frame.origin.x = underlineFinalXPosition
        }
    }

    private func setuptTextAttributes() {
        self.setTitleTextAttributes(
            [
                NSAttributedString.Key.foregroundColor: UIColor.gray500,
                .font: UIFont.pickFont(.body1)
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
