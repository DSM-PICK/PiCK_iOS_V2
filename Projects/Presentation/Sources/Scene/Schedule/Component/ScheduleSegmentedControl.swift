import UIKit

public class ScheduleSegmentedControl: UISegmentedControl {
    public override init(items: [Any]?) {
        super.init(items: items)
        self.selectedSegmentIndex = 0
        self.selectedSegmentTintColor = UIColor.main50
        self.backgroundColor = .clear
        self.layer.cornerRadius = 0
        self.layer.masksToBounds = true
        self.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.gray600,
            .font: UIFont.pickFont(.label1)
        ], for: .normal)
        self.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.modeBlack
        ], for: .selected)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
