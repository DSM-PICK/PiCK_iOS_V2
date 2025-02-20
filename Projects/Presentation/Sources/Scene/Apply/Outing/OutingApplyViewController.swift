import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import DesignSystem

public class OutingApplyViewController: BaseViewController<OutingApplyViewModel> {
    private var startTimeRelay = BehaviorRelay<String>(value: "")
    private var endTimeRelay = BehaviorRelay<String>(value: "")
    private var applicationType = BehaviorRelay<PickerTimeSelectType>(value: .time)

    private let userDefaultStorage = UserDefaultStorage.shared

    private var pickerType: PickerTimeSelectType {
        let value = userDefaultStorage.getUserDataType(
            forKey: .pickerTimeMode,
            type: PickerTimeSelectType.self
        ) as? PickerTimeSelectType

        if value == .period {
            self.explainLabel.text = "희망 외출 교시를 선택하세요"
        } else {
            self.explainLabel.text = "희망 외출 시간을 선택하세요"
        }

        return value ?? .time
    }

    private let titleLabel = PiCKLabel(
        text: "외출 신청",
        textColor: .modeBlack,
        font: .pickFont(.heading4)
    )
    private lazy var explainLabel = PiCKLabel(
        textColor: .modeBlack,
        font: .pickFont(.label1)
    )
    private let startTimeSelectButton = TimeSelectButton(type: .system)
    private let sinceLabel = PiCKLabel(
        text: "부터",
        textColor: .modeBlack,
        font: .pickFont(.label1)
    )
    private let endTimeSelectButton = TimeSelectButton(type: .system)
    private let untilLabel = PiCKLabel(
        text: "까지",
        textColor: .modeBlack,
        font: .pickFont(.label1)
    )
    private let periodSelectButton = TimeSelectButton(type: .system)
    private lazy var outingTimeStackView = UIStackView(arrangedSubviews: [
        startTimeSelectButton,
        sinceLabel,
        endTimeSelectButton,
        untilLabel,
        periodSelectButton
    ]).then {
        $0.axis = .horizontal
        $0.spacing = 12
    }
    private let outingReasonTextView = PiCKTextView(
        title: "외출 사유를 입력하세요",
        placeholder: "자세히 입력해주세요"
    )
    private let applyButton = PiCKButton(buttonText: "신청하기")

    public override func attribute() {
        super.attribute()

        navigationTitleText = "외출 신청"
    }
    public override func bind() {
        let input = OutingApplyViewModel.Input(
            startTime: startTimeRelay.asObservable(),
            clickStartTimeButton: startTimeSelectButton.buttonTap.asObservable(),
            endTime: endTimeRelay.asObservable(),
            clickEndTimeButton: endTimeSelectButton.buttonTap.asObservable(),
            reasonText: outingReasonTextView.textViewText.asObservable(),
            applicationType: applicationType.asObservable(),
            clickOutingApply: applyButton.buttonTap.asObservable()
        )

        let output =  viewModel.transform(input: input)

        output.isApplyButtonEnable
            .asObservable()
            .withUnretained(self)
            .bind { owner, isEnabled in
                owner.applyButton.isEnabled = isEnabled
            }.disposed(by: disposeBag)
    }

    public override func bindAction() {
        startTimeSelectButton.buttonTap
            .bind { [weak self] in
                let alert = PiCKApplyTimePickerAlert(type: .outingStart)

                alert.selectedTime = { [weak self] hour, min in
                    self?.startTimeRelay.accept("\(hour):\(min)")
                    self?.startTimeSelectButton.setup(
                        text: "\(hour)시 \(min)분"
                    )
                }

                self?.presentAsCustomDents(view: alert, height: 406)
            }.disposed(by: disposeBag)

        endTimeSelectButton.buttonTap
            .bind { [weak self] in
                let alert = PiCKApplyTimePickerAlert(type: .outingEnd)

                alert.selectedTime = { [weak self] hour, min in
                    self?.endTimeRelay.accept("\(hour):\(min)")
                    self?.endTimeSelectButton.setup(
                        text: "\(hour)시 \(min)분"
                    )

                    self?.applicationType.accept(.time)
                }

                self?.presentAsCustomDents(view: alert, height: 406)
            }.disposed(by: disposeBag)

        periodSelectButton.buttonTap
            .bind { [weak self] in
                let alert = PiCKApplyTimePickerAlert(type: .outingPeriod)

                alert.selectedPeriod = { [weak self] startPeriod, endPeriod in
                    self?.startTimeRelay.accept("\(startPeriod)")
                    self?.endTimeRelay.accept("\(endPeriod)")
                    self?.periodSelectButton.setup(
                        text: "\(startPeriod)교시 부터\t\t\(endPeriod)교시 까지"
                    )

                    self?.applicationType.accept(.period)
                }
                alert.clickApplyButton = {
                    print("success")
                }

                self?.presentAsCustomDents(view: alert, height: 406)
            }.disposed(by: disposeBag)
    }

    public override func addView() {
        [
            titleLabel,
            explainLabel,
            outingTimeStackView,
            outingReasonTextView,
            applyButton
        ].forEach { view.addSubview($0) }
    }
    public override func setLayout() {
        switch pickerType {
        case .time:
            periodSelectButton.isHidden = true

            outingTimeStackView.snp.makeConstraints {
                $0.top.equalTo(explainLabel.snp.bottom).offset(12)
                $0.leading.equalToSuperview().inset(24)
                $0.height.equalTo(43)
            }
        case .period:
            let array = [
                startTimeSelectButton,
                sinceLabel,
                endTimeSelectButton,
                untilLabel
            ]
            array.forEach { $0.isHidden = true }

            outingTimeStackView.snp.makeConstraints {
                $0.top.equalTo(explainLabel.snp.bottom).offset(12)
                $0.leading.trailing.equalToSuperview().inset(24)
                $0.height.equalTo(43)
            }
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(32)
            $0.leading.equalToSuperview().inset(24)
        }
        explainLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(24)
        }
        outingReasonTextView.snp.makeConstraints {
            $0.top.equalTo(outingTimeStackView.snp.bottom).offset(68)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(151)
        }
        applyButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(60)
        }
    }

}
