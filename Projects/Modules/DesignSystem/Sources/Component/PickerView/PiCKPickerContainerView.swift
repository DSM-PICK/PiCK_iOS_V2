import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa
import RxGesture

import Core

public class PiCKPickerContainerView: BaseView {
    public lazy var startPeriodValue = startPeriodPickerView.periodText.value
    public lazy var endPeriodValue = endPeriodPickerView.periodText.value

    private let backgroudView = UIView().then {
        $0.backgroundColor = .clear
    }
    private let componentBackgroundView = UIView().then {
        $0.backgroundColor = .main50
        $0.layer.cornerRadius = 12
    }

    private let startPeriodPickerView = PiCKPickerView()
    private let startPeriodLabel = PiCKLabel(text: "교시", textColor: .modeBlack, font: .subTitle1)
    private lazy var startPeriodStackView = UIStackView(arrangedSubviews: [
        startPeriodPickerView,
        startPeriodLabel
    ]).then {
        $0.axis = .horizontal
    }

    private let dashLabel = PiCKLabel(text: "-", textColor: .modeBlack, font: .heading3)

    private let endPeriodPickerView = PiCKPickerView()
    private let endPeriodLabel = PiCKLabel(text: "교시", textColor: .modeBlack, font: .subTitle1)
    private lazy var endPeriodStackView = UIStackView(arrangedSubviews: [
        endPeriodPickerView,
        endPeriodLabel
    ]).then {
        $0.axis = .horizontal
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        pickerViewSetting()
    }
    public override func layout() {
        self.addSubview(backgroudView)
        [
            componentBackgroundView,
            startPeriodStackView,
            dashLabel,
            endPeriodStackView
        ].forEach { backgroudView.addSubview($0) }

        backgroudView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(200)
        }
        componentBackgroundView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(52)
        }
        startPeriodPickerView.snp.makeConstraints {
            $0.width.equalTo(44)
        }
        endPeriodPickerView.snp.makeConstraints {
            $0.width.equalTo(44)
        }
        startPeriodStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(60)
        }
        dashLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        endPeriodStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(60)
        }
    }

    private func pickerViewSetting() {
        startPeriodPickerView.subviews[1].backgroundColor = .clear
        endPeriodPickerView.subviews[1].backgroundColor = .clear
    }

}
