import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core

public class PiCKApplyTimePickerAlert: UIViewController {
    private let disposeBag = DisposeBag()

    public var clickApplyButton: (() -> Void)?
    public var selectedPeriod: ((Int, Int) -> Void)?

    private var startPeriod = BehaviorRelay<Int>(value: 1)
    private var endPeriod = BehaviorRelay<Int>(value: 1)

    private let explainLabel = PiCKLabel(
        text: "교실 이동 시간을 선택해주세요",
        textColor: .modeBlack,
        font: .label1
    )
    private let periodPickerView = PiCKPickerContainerView()
    private let applyButton = PiCKButton(buttonText: "신청하기")

    public override func viewDidLoad() {
        super.viewDidLoad()

        attribute()
        bind()
    }
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        layout()
    }
    private func attribute() {
        view.backgroundColor = .background
        view.layer.cornerRadius = 20
    }
    private func bind() {
        applyButton.buttonTap
            .bind(onNext: { [weak self] in
                self?.dismiss(animated: true)
                self?.selectedPeriod!(self?.periodPickerView.startPeriodValue ?? 0, self?.periodPickerView.endPeriodValue ?? 0)
                self?.clickApplyButton!()
            }).disposed(by: disposeBag)
    }
    private func layout() {
        [
            explainLabel,
            periodPickerView,
            applyButton
        ].forEach { view.addSubview($0) }

        explainLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(24)
        }
        periodPickerView.snp.makeConstraints {
            $0.top.equalTo(explainLabel.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(204)
        }
        applyButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(60)
        }
    }

}
