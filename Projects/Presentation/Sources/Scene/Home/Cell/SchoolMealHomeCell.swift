import UIKit

import SnapKit
import Then

import Core
import Domain
import DesignSystem

public class SchoolMealHomeCell: BaseCollectionViewCell<(String, MealEntityElement)> {
    static let identifier = "SchoolMealCollectionViewCell"

    private let mealTimeLabel = PiCKLabel(textColor: .main700, font: .subTitle1)
    private let menuLabel = PiCKLabel(textColor: .modeBlack, font: .body1, numberOfLines: 0)
    private let kcalLabel = PiCKLabel(
        textColor: .background,
        font: .caption2,
        alignment: .center,
        backgroundColor: .main500,
        cornerRadius: 12
    )

//    public override func adapt(model: (String, MealEntityElement)) {
//        super.adapt(model: model)
//
//        self.mealTimeLabel.text = model.0
//        self.menuLabel.text = model.1.menu.joined(separator: "\n")
//        self.kcalLabel.text = model.1.kcal
//    }
    public func setup(
        mealTime: String,
        menu: [String],
        kcal: String
    ) {
        self.mealTimeLabel.text = mealTime
        self.menuLabel.text = menu.joined(separator: "\n")
        self.kcalLabel.text = kcal
    }
    
    public override func layout() {
        [
            mealTimeLabel,
            menuLabel,
            kcalLabel
        ].forEach { self.addSubview($0) }

        mealTimeLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(24)
        }
        menuLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(mealTimeLabel.snp.trailing).offset(70)
        }
        kcalLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(24)
            $0.width.equalTo(76)
            $0.height.equalTo(24)
        }
    }

}
