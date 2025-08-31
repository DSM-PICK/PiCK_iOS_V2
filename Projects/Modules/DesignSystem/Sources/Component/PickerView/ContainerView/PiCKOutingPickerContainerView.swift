import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core

public class PiCKOutingPickerContainerView: BaseView {
    public lazy var outingHourValue = hourPickerView.hourText.value
    public lazy var outingMinValue = minPickerView.minText.value

    public override init(frame: CGRect) {
        super.init(frame: frame)

        hourPickerView.pickerDelegate = self
        minPickerView.pickerDelegate = self
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
extension PiCKOutingPickerContainerView: PiCKPickerViewDelegate {
    public func pickerViewDidChangeValue(_ pickerView: PiCKPickerView, type: PickerTimeType, value: Int) {

        if type == .hour && value == 20 {
            if minPickerView.minText.value > 30 {
                minPickerView.minText.accept(30)
                minPickerView.selectRow(30, inComponent: 0, animated: true)
            }
        } else if type == .min && value > 30 && hourPickerView.hourText.value == 20 {
            minPickerView.minText.accept(30)
            minPickerView.selectRow(30, inComponent: 0, animated: true)
        }
    }
}
