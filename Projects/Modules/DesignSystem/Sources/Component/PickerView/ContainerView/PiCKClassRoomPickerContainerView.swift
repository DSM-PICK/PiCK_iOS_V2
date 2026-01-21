import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa
import RxGesture

import Core

public class PiCKClassroomPickerContainerView: BaseView {
    public lazy var startPeriodValue = startPickerView.periodText.value
    public lazy var endPeriodValue = endPickerView.periodText.value
    public lazy var periodValue = startPickerView.periodText.value

    private let isSingleSelection: Bool

    private let backgroudView = UIView().then {
        $0.backgroundColor = .clear
    }
    private let componentBackgroundView = UIView().then {
        $0.backgroundColor = .main50
        $0.layer.cornerRadius = 12
    }

    private let startPickerView = PiCKPickerView(type: .period)
    private let startPeriodLabel = PiCKLabel(text: "교시", textColor: .modeBlack, font: .pickFont(.subTitle1))
    private lazy var startPeriodStackView = UIStackView(arrangedSubviews: [
        startPickerView,
        startPeriodLabel
    ]).then {
        $0.axis = .horizontal
    }

    private let dashLabel = PiCKLabel(text: "-", textColor: .modeBlack, font: .pickFont(.heading3))

    private let endPickerView = PiCKPickerView(type: .period)
    private let endPeriodLabel = PiCKLabel(text: "교시", textColor: .modeBlack, font: .pickFont(.subTitle1))
    private lazy var endPeriodStackView = UIStackView(arrangedSubviews: [
        endPickerView,
        endPeriodLabel
    ]).then {
        $0.axis = .horizontal
    }

    public init(isSingleSelection: Bool = false) {
        self.isSingleSelection = isSingleSelection
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        self.isSingleSelection = false
        super.init(coder: coder)
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
            $0.height.equalTo(42)
        }
        startPickerView.snp.makeConstraints {
            $0.width.equalTo(44)
        }
        endPickerView.snp.makeConstraints {
            $0.width.equalTo(44)
        }

        if isSingleSelection {
            dashLabel.isHidden = true
            endPeriodStackView.isHidden = true

            startPeriodStackView.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        } else {
            dashLabel.isHidden = false
            endPeriodStackView.isHidden = false

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
    }

    private func pickerViewSetting() {
        startPickerView.subviews[1].backgroundColor = .clear
        if !isSingleSelection {
            endPickerView.subviews[1].backgroundColor = .clear
        }
    }

}
