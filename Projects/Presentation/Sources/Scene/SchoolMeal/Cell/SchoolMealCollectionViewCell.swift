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
    private let kcalLabel = PiCKLabel(
        textColor: .modeWhite,
        font: .caption2,
        alignment: .center,
        backgroundColor: .main500,
        cornerRadius: 12
    )
    private let menuLabel = PiCKLabel(
        textColor: .modeBlack,
        font: .label1,
        numberOfLines: 0,
        alignment: .left
    )
    private lazy var infoStackView = UIStackView(arrangedSubviews: [
        mealTimeLabel,
        kcalLabel
    ]).then {
        $0.axis = .vertical
        $0.spacing = 16
        $0.alignment = .center
        $0.distribution = .fillEqually
    }

    public func setup(
        mealTime: String,
        menu: [String],
        kcal: String
    ) {
        self.mealTimeLabel.text = mealTime

        if menu.isEmpty {
            self.kcalLabel.isHidden = true
            self.menuLabel.text = "급식이 없습니다"
        } else {
            self.kcalLabel.isHidden = false
            self.menuLabel.text = menu.joined(separator: "\n")
            self.kcalLabel.text = kcal
        }
    }

    public override func attribute() {
        self.backgroundColor = .background
        self.layer.cornerRadius = 8
        self.layer.border(color: .main50, width: 2)
        self.layer.masksToBounds = true
    }
    public override func layout() {
        [
            menuLabel,
            infoStackView
        ].forEach { self.addSubview($0) }

        infoStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(40)
        }
        kcalLabel.snp.makeConstraints {
            $0.width.equalTo(75)
            $0.height.equalTo(22)
        }
        menuLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().inset(190)
            $0.trailing.equalToSuperview().inset(10)
        }
    }

}
