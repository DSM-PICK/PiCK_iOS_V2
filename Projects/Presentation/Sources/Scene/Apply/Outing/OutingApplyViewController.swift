import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import DesignSystem

public class OutingApplyViewController: BaseViewController<OutingApplyViewModel> {
    private var startTime = BehaviorRelay<String>(value: "")
    private var endTime = BehaviorRelay<String>(value: "")

    private let titleLabel = PiCKLabel(text: "외출 신청", textColor: .modeBlack, font: .heading4)
    private let explainLabel = PiCKLabel(text: "희망 외출 시간을 선택하세요", textColor: .modeBlack, font: .label1)
    private let startTimeSelectButton = TimeSelectButton(type: .system)
    private let sinceLabel = PiCKLabel(text: "부터", textColor: .modeBlack, font: .label1)
    private let endTimeSelectButton = TimeSelectButton(type: .system)
    private let untilLabel = PiCKLabel(text: "까지", textColor: .modeBlack, font: .label1)
    private lazy var outingTimeStackView = UIStackView(arrangedSubviews: [
        startTimeSelectButton,
        sinceLabel,
        endTimeSelectButton,
        untilLabel
    ]).then {
        $0.axis = .horizontal
        $0.spacing = 12
    }
    private let outingReasonTextView = PiCKTextView(title: "외출 사유를 입력하세요", placeholder: "자세히 입력해주세요")
    private let applyButton = PiCKButton(type: .system, buttonText: "신청하기", isEnabled: false)

    public override func attribute() {
        super.attribute()
        
        navigationTitleText = "외출 신청"
    }
    public override func bind() {
        let input = OutingApplyViewModel.Input(
            startTime: startTime.asObservable(),
            clickStartTimeButton: startTimeSelectButton.buttonTap.asObservable(),
            endTime: endTime.asObservable(),
            clickEndTimeButton: endTimeSelectButton.buttonTap.asObservable(),
            reasonText: outingReasonTextView.textViewText.asObservable(),
            clickOutingApply: applyButton.buttonTap.asObservable()
        )

        let output =  viewModel.transform(input: input)

        output.isApplyButtonEnable.asObservable()
            .bind(
                onNext: { [weak self] isEnabled in
                    self?.applyButton.isEnabled = isEnabled
                }
            ).disposed(by: disposeBag)
    }

    public override func bindAction() {
        startTimeSelectButton.buttonTap
            .bind(onNext: { [weak self] in
                let vc = PiCKApplyTimePickerAlert(type: .outingStart)
                vc.selectedTime = { [weak self] hour, min in
                    self?.startTime.accept("\(hour):\(min)")
                    self?.startTimeSelectButton.setup(text: "\(hour)시 \(min)분")
                }
                self?.presentAsCustomDents(view: vc, height: 406)
            }).disposed(by: disposeBag)

        endTimeSelectButton.buttonTap
            .bind(onNext: { [weak self] in
                let vc = PiCKApplyTimePickerAlert(type: .outingEnd)
                vc.selectedTime = { [weak self] hour, min in
                    self?.endTime.accept("\(hour):\(min)")
                    self?.endTimeSelectButton.setup(text: "\(hour)시 \(min)분")
                }
                self?.presentAsCustomDents(view: vc, height: 406)
            }).disposed(by: disposeBag)
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
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            $0.leading.equalToSuperview().inset(24)
        }
        explainLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(24)
        }
        outingTimeStackView.snp.makeConstraints {
            $0.top.equalTo(explainLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(24)
            $0.height.equalTo(43)
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
