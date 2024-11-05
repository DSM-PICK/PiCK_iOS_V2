import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import DesignSystem

public class WeekendMealApplyView: BaseView {
    public var clickWeekendMealStatus: (WeekendMealType) -> Void

    public var applyState = BehaviorRelay<Bool>(value: false)

    private lazy var currnetMonthWeekendMealApplyLabel = PiCKLabel(
        textColor: .modeBlack,
        font: .body1
    )
    private let applyButton = WeekendMealApplyButton(buttonText: "신청")
    private let notApplyButton = WeekendMealApplyButton(buttonText: "미신청")
    private lazy var buttonStackView = UIStackView(arrangedSubviews: [
        applyButton,
        notApplyButton
    ]).then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fillEqually
    }

    public func setup(
        status: Bool,
        isApplicable: Bool,
        month: Int
    ) {
        if isApplicable == true {
            self.currnetMonthWeekendMealApplyLabel.text = "\(month)월 주말 급식 신청"
        } else {
            let statusText = status ? "신청입니다" : "미신청입니다"
            self.currnetMonthWeekendMealApplyLabel.text = "주말 급식 신청 상태는 \(statusText)"
            self.currnetMonthWeekendMealApplyLabel.changePointColor(targetString: "\(statusText)", color: .main500)
        }

        self.buttonStackView.isHidden = !isApplicable
        self.applyState.accept(status)
    }

    public init(
        clickWeekendMealStatus: @escaping (WeekendMealType) -> Void
    ) {
        self.clickWeekendMealStatus = clickWeekendMealStatus
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func attribute() {
        super.attribute()

        self.backgroundColor = .gray50
        self.layer.cornerRadius = 8
    }
    public override func bind() {
        applyState.asObservable()
            .withUnretained(self)
            .bind { owner, data in
                owner.applyButton.isSelected = data
                owner.notApplyButton.isSelected = !data
            }.disposed(by: disposeBag)

        applyButton.buttonTap
            .bind { [self] in
                clickRadioButton(button: applyButton)
            }.disposed(by: disposeBag)

        notApplyButton.buttonTap
            .bind { [self] in
                clickRadioButton(button: notApplyButton)
            }.disposed(by: disposeBag)
    }
    public override func layout() {
        [
            currnetMonthWeekendMealApplyLabel,
            buttonStackView
        ].forEach { self.addSubview($0) }

        currnetMonthWeekendMealApplyLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
        }
        buttonStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
        }
    }

    private func clickRadioButton(button: WeekendMealApplyButton) {
        if button == applyButton {
            applyState.accept(true)
        } else if button == notApplyButton {
            applyState.accept(false)
        }

        applyButton.isSelected = applyState.value
        notApplyButton.isSelected = !applyState.value

        clickWeekendMealStatus(applyState.value == true ? .ok : .no)
    }

}
