import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core

public class PiCKOutingPickerContainerView: BaseView {
    public lazy var outingHourValue = hourPickerView.hourText.value
    public lazy var outingMinValue = minPickerView.minText.value

    private let backgroudView = UIView().then {
        $0.backgroundColor = .clear
    }
    private let componentBackgroundView = UIView().then {
        $0.backgroundColor = .main50
        $0.layer.cornerRadius = 12
    }

    private let hourPickerView = PiCKPickerView(type: .hour)
    private let hourLabel = PiCKLabel(
        text: "시",
        textColor: .modeBlack,
        font: .pickFont(.subTitle1)
    )
    private lazy var startStackView = UIStackView(arrangedSubviews: [
        hourPickerView,
        hourLabel
    ]).then {
        $0.axis = .horizontal
    }
    private let dashLabel = PiCKLabel(
        text: "-",
        textColor: .modeBlack,
        font: .pickFont(.heading3)
    )
    private let minPickerView = PiCKPickerView(type: .min)
    private let minLabel = PiCKLabel(
        text: "분",
        textColor: .modeBlack,
        font: .pickFont(.subTitle1)
    )
    private lazy var endStackView = UIStackView(arrangedSubviews: [
        minPickerView,
        minLabel
    ]).then {
        $0.axis = .horizontal
    }
    private lazy var backStackView = UIStackView(arrangedSubviews: [
        startStackView,
        dashLabel,
        endStackView
    ]).then {
        $0.axis = .horizontal
        $0.spacing = 20
        $0.distribution = .fillEqually
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        pickerViewSetting()
    }
    public override func layout() {
        self.addSubview(backgroudView)
        [
            componentBackgroundView,
            startStackView,
            dashLabel,
            endStackView
        ].forEach { backgroudView.addSubview($0) }

        backgroudView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(200)
        }
        componentBackgroundView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(42)
        }
        hourPickerView.snp.makeConstraints {
            $0.width.equalTo(44)
        }
        minPickerView.snp.makeConstraints {
            $0.width.equalTo(44)
        }
        startStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(60)
        }
        dashLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        endStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(60)
        }
    }

    private func pickerViewSetting() {
        hourPickerView.subviews[1].backgroundColor = .clear
        minPickerView.subviews[1].backgroundColor = .clear
    }

}
