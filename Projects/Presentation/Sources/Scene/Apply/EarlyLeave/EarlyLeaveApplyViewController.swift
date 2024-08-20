
import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import DesignSystem

public class EarlyLeaveApplyViewController: BaseViewController<EarlyLeaveApplyViewModel> {
    private var startTime = BehaviorRelay<String>(value: "")

    private let titleLabel = PiCKLabel(text: "조기 귀가 신청", textColor: .modeBlack, font: .heading4)
    private let explainLabel = PiCKLabel(text: "희망 귀가 시간을 선택하세요", textColor: .modeBlack, font: .label1)
    private let startTimeSelectButton = TimeSelectButton(type: .system)
    private let outingReasonTextView = PiCKTextView(title: "귀가 사유를 입력하세요", placeholder: "자세히 입력해주세요")
    private let applyButton = PiCKButton(type: .system, buttonText: "신청하기", isEnabled: false)

    public override func attribute() {
        super.attribute()
        
        navigationTitleText = "조기 귀가 신청"
    }
    public override func bind() {
        let input = EarlyLeaveApplyViewModel.Input(
            startTime: startTime.asObservable(),
            clickStartTime: startTimeSelectButton.buttonTap.asObservable(),
            reasonText: outingReasonTextView.textViewText.asObservable(),
            clickEarlyLeaveApply: applyButton.buttonTap.asObservable()
        )
        let output =  viewModel.transform(input: input)
        
        output.isApplyButtonEnable.asObservable()
            .bind(
                onNext: { [weak self] isEnabled in
                    self?.applyButton.isEnabled = isEnabled
                }
            ).disposed(by: disposeBag)

        startTimeSelectButton.buttonTap
            .bind {
                let vc = PiCKApplyTimePickerAlert(type: .outingStart)
                vc.selectedTime = { [weak self] hour, min in
                    self?.startTime.accept("\(hour):\(min)")
                    self?.startTimeSelectButton.setTitle("\(hour)시 \(min)분", for: .normal)
                }
                self.presentAsCustomDents(view: vc, height: 406)
            }.disposed(by: disposeBag)
    }
    public override func addView() {
        [
            titleLabel,
            explainLabel,
            startTimeSelectButton,
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
        startTimeSelectButton.snp.makeConstraints {
            $0.top.equalTo(explainLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(24)
        }
        outingReasonTextView.snp.makeConstraints {
            $0.top.equalTo(startTimeSelectButton.snp.bottom).offset(68)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(151)
        }
        applyButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(60)
        }

    }

}
