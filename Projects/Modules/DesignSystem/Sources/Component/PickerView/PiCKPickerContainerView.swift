import UIKit

import SnapKit
import Then

import Core

public class PiCKPickerContainerView: BaseView {
    private let backgroudView = UIView().then {
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
        $0.spacing = 24
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        
        pickerViewSetting()
    }
    public override func layout() {
        self.addSubview(backgroudView)
        [
            startPeriodStackView,
            dashLabel,
            endPeriodStackView
        ].forEach { backgroudView.addSubview($0) }
        
        backgroudView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(52)
        }
        startPeriodPickerView.snp.makeConstraints {
            $0.height.equalTo(200)
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
