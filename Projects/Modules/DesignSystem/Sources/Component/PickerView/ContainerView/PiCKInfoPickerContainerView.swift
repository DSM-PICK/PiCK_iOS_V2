import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import Core

public class PiCKInfoContainerView: BaseView {
    public lazy var gradeValue = gradePickerView.gradeText.value
    public lazy var classValue = classPickerView.classText.value
    public lazy var numberValue = numberPickerView.numberText.value

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let backgroundView = UIView().then {
        $0.backgroundColor = .clear
    }

    private let componentBackgroundView = UIView().then {
        $0.backgroundColor = .main50
        $0.layer.cornerRadius = 12
    }

    private let gradePickerView = PiCKPickerView(type: .grade)
    private let gradeLabel = PiCKLabel(
        text: "학년",
        textColor: .modeBlack,
        font: .pickFont(.subTitle1)
    )

    private lazy var gradeStackView = UIStackView(arrangedSubviews: [
        gradePickerView,
        gradeLabel
    ]).then {
        $0.axis = .horizontal
    }

    private let classPickerView = PiCKPickerView(type: .class)
    private let classLabel = PiCKLabel(
        text: "반",
        textColor: .modeBlack,
        font: .pickFont(.subTitle1)
    )

    private lazy var classStackView = UIStackView(arrangedSubviews: [
        classPickerView,
        classLabel
    ]).then {
        $0.axis = .horizontal
    }

    private let numberPickerView = PiCKPickerView(type: .number)
    private let numberLabel = PiCKLabel(
        text: "번",
        textColor: .modeBlack,
        font: .pickFont(.subTitle1)
    )

    private lazy var numberStackView = UIStackView(arrangedSubviews: [
        numberPickerView,
        numberLabel
    ]).then {
        $0.axis = .horizontal
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        pickerViewSetting()
    }

    public override func layout() {
        self.addSubview(backgroundView)
        [
            componentBackgroundView,
            gradeStackView,
            classStackView,
            numberStackView
        ].forEach { backgroundView.addSubview($0) }

        backgroundView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(200)
        }

        componentBackgroundView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(42)
        }

        gradePickerView.snp.makeConstraints {
            $0.width.equalTo(44)
        }

        classPickerView.snp.makeConstraints {
            $0.width.equalTo(44)
        }

        numberPickerView.snp.makeConstraints {
            $0.width.equalTo(44)
        }

        gradeStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(30)
        }

        classStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview()
        }

        numberStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(30)
        }
    }

    private func pickerViewSetting() {
        gradePickerView.subviews[1].backgroundColor = .clear
        classPickerView.subviews[1].backgroundColor = .clear
        numberPickerView.subviews[1].backgroundColor = .clear
    }
}
