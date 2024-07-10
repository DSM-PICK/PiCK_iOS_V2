import UIKit

import SnapKit
import Then

import Core
import DesignSystem

public class SchoolMealCollectionViewCell: BaseCollectionViewCell {
    
    static let identifier = "SchoolMealCollectionViewCell"
    
    private let mealTimeLabel = UILabel().then {
        $0.textColor = .main700
        $0.font = .subTitle1
    }
    private let menuLabel = UILabel().then {
        $0.textColor = .modeBlack
        $0.font = .body1
        $0.numberOfLines = 0
    }
    private let kcalLabel = UILabel().then {
        $0.textColor = .background
        $0.font = .caption2
        $0.backgroundColor = .main500
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.textAlignment = .center
    }
    
    public func setup(
        mealTime: String,
        menu: String,
        kcal: String
    ) {
        self.mealTimeLabel.text = mealTime
        self.menuLabel.text = menu
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
