import UIKit

import SnapKit
import Then

import Core
import DesignSystem

public class SchoolMealCollectionViewCell: BaseCollectionViewCell<Any> {
    static let identifier = "SchoolMealTableViewCell"

    private let mealTimeLabel = PiCKLabel(
        textColor: .main700,
        font: .subTitle1
    )
    private let menuLabel = PiCKLabel(
        textColor: .modeBlack,
        font: .label1,
        numberOfLines: 0
    )

    public func setup(
        mealTime: String,
        menu: String
    ) {
        self.mealTimeLabel.text = mealTime
        self.menuLabel.text = menu
    }

    public override func attribute() {
        self.backgroundColor = .main50
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
    }
    public override func layout() {
        [
            mealTimeLabel,
            menuLabel
        ].forEach { self.addSubview($0) }

        mealTimeLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(40)
        }
        menuLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(40)
        }
    }

}
