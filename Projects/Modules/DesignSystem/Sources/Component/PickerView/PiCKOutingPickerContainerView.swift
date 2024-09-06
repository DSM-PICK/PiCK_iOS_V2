import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa
import RxGesture

import Core

public class PiCKOutingPickerContainerView: BaseView {
    private let userDefaultStorage = UserDefaultsManager.shared

    private var timeSelectType: PickerTimeType {
        let value = userDefaultStorage.getUserDataType(
            forKey: .pickerTimeMode,
            type: PickerTimeSelectType.self
        ) as? PickerTimeSelectType

        if value == .period {
            return .period
        }

        return .hour
    }

    public lazy var outingHourValue = startPickerView.hourText.value
    public lazy var outingMinValue = endPickerView.minText.value

    private let backgroudView = UIView().then {
        $0.backgroundColor = .clear
    }
    private let componentBackgroundView = UIView().then {
        $0.backgroundColor = .main50
        $0.layer.cornerRadius = 12
    }

    private lazy var startPickerView = PiCKPickerView(type: timeSelectType)
    private let hourLabel = PiCKLabel(text: "시", textColor: .modeBlack, font: .subTitle1)
    private lazy var startStackView = UIStackView(arrangedSubviews: [
        startPickerView,
        hourLabel
    ]).then {
        $0.axis = .horizontal
    }

    private let dashLabel = PiCKLabel(text: "-", textColor: .modeBlack, font: .heading3)

    private lazy var endPickerView = PiCKPickerView(type: timeSelectType)
    private let minLabel = PiCKLabel(text: "분", textColor: .modeBlack, font: .subTitle1)
    private lazy var endStackView = UIStackView(arrangedSubviews: [
        endPickerView,
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
        switch timeSelectType {
        case .period:
            self.hourLabel.text = "교시"
            self.minLabel.text = "교시"
            self.endStackView.isHidden = true
        case .hour:
            self.hourLabel.text = "시"
        case .min:
            self.minLabel.text = "분"
        }
    }
    public override func layout() {
        self.addSubview(backgroudView)
        [
            componentBackgroundView,
//            startStackView,
//            dashLabel,
//            endStackView
            backStackView
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
        backStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        startPickerView.snp.makeConstraints {
            $0.width.equalTo(44)
        }
        endPickerView.snp.makeConstraints {
            $0.width.equalTo(44)
        }
//        startStackView.snp.makeConstraints {
//            $0.centerY.equalToSuperview()
//            $0.leading.equalToSuperview().inset(60)
//        }
//        dashLabel.snp.makeConstraints {
//            $0.center.equalToSuperview()
//        }
//        endStackView.snp.makeConstraints {
//            $0.centerY.equalToSuperview()
//            $0.trailing.equalToSuperview().inset(60)
//        }
    }

    private func pickerViewSetting() {
        startPickerView.subviews[1].backgroundColor = .clear
        endPickerView.subviews[1].backgroundColor = .clear
    }

}
