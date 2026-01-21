import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import DesignSystem

public class EarlyLeaveApplyViewController: BaseViewController<EarlyLeaveApplyViewModel> {
    private let userDefaultStorage = UserDefaultStorage.shared
    private var applicationType = BehaviorRelay<PickerTimeSelectType>(value: PickerTimeSelectType.time)

    private var startTimeRelay = BehaviorRelay<String>(value: "")

    private var pickerType: PickerTimeSelectType {
        let value = userDefaultStorage.getUserDataType(
            forKey: .pickerTimeMode,
            type: PickerTimeSelectType.self
        ) as? PickerTimeSelectType

        if value == .period {
            self.explainLabel.text = "희망 귀가 교시를 선택하세요"
        } else {
            self.explainLabel.text = "희망 귀가 시간을 선택하세요"
        }

        return value ?? .time
    }

    private let titleLabel = PiCKLabel(
        text: "조기 귀가 신청",
        textColor: .modeBlack,
        font: .pickFont(.heading4)
    )
    private lazy var explainLabel = PiCKLabel(
        textColor: .modeBlack,
        font: .pickFont(.label1)
    )
    private let startTimeSelectButton = TimeSelectButton(type: .system)
    private let periodSelectButton = TimeSelectButton(type: .system)
    private let outingReasonTextView = PiCKTextView(
        title: "귀가 사유를 입력하세요",
        placeholder: "자세히 입력해주세요"
    )
    private let applyButton = PiCKButton(
        buttonText: "신청하기",
        isEnabled: false
    )

    public override func attribute() {
        super.attribute()

        navigationTitleText = "조기 귀가 신청"
    }
    public override func bind() {
        let input = EarlyLeaveApplyViewModel.Input(
            startTime: startTimeRelay.asObservable(),
            selectStartTimeButtonDidTap: startTimeSelectButton.buttonTap.asObservable(),
            reasonText: outingReasonTextView.textViewText.asObservable(),
            applicationType: applicationType.asObservable(),
            earlyLeaveApplyButtonDidTap: applyButton.buttonTap.asObservable()
        )
        let output =  viewModel.transform(input: input)

        output.isApplyButtonEnable.asObservable()
            .withUnretained(self)
            .bind { owner, isEnabled in
                owner.applyButton.isEnabled = isEnabled
            }.disposed(by: disposeBag)

        startTimeSelectButton.buttonTap
            .bind { [weak self] in
                let alert = PiCKApplyTimePickerAlert(type: .earlyLeave)
                alert.selectedTime = { [weak self] hour, min in
                    self?.startTimeRelay.accept("\(hour):\(min)")
                    self?.startTimeSelectButton.setup(text: "\(hour)시 \(min)분")
                    self?.applicationType.accept(PickerTimeSelectType.time)
                }
                self?.presentAsCustomDents(view: alert, height: 406)
            }.disposed(by: disposeBag)

        periodSelectButton.buttonTap
            .bind { [weak self] in
                let alert = PiCKApplyTimePickerAlert(type: .earlyLeavePeriod)
                alert.selectEarlyLeavePeriod = { [weak self] period in
                    self?.startTimeRelay.accept("\(period)")
                    self?.periodSelectButton.setup(text: "\(period)교시")
                    self?.applicationType.accept(.period)
                }
                self?.presentAsCustomDents(view: alert, height: 406)
            }.disposed(by: disposeBag)
    }

    public override func addView() {
        [
            titleLabel,
            explainLabel,
            startTimeSelectButton,
            periodSelectButton,
            outingReasonTextView,
            applyButton
        ].forEach { view.addSubview($0) }
    }
    public override func setLayout() {
        switch pickerType {
        case .time:
            startTimeSelectButton.isHidden = false
            periodSelectButton.isHidden = true
        case .period:
            startTimeSelectButton.isHidden = true
            periodSelectButton.isHidden = false
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(32)
            $0.leading.equalToSuperview().inset(24)
        }
        explainLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(24)
        }
        let activeButton = pickerType == .time ? startTimeSelectButton : periodSelectButton
        activeButton.snp.makeConstraints {
            $0.top.equalTo(explainLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(24)
        }
        outingReasonTextView.snp.makeConstraints {
            $0.top.equalTo(activeButton.snp.bottom).offset(68)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(151)
        }
        applyButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(60)
        }
    }

}
