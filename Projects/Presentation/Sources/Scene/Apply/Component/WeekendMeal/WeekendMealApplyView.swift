import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import DesignSystem

public class WeekendMealApplyView: BaseView {
    public var applyState: Bool = false
    private let applyDate = Date()
    private let calendar = Calendar.current
    private lazy var nextMonth = calendar.date(byAdding: .month, value: 1, to: applyDate)

    private lazy var currnetMonthWeekendMealApplyLabel = PiCKLabel(
        text: "\(nextMonth?.toString(type: .month) ?? "Error") 주말 급식 신청",
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

    public override func attribute() {
        super.attribute()

        self.backgroundColor = .gray50
        self.layer.cornerRadius = 8
    }
    public override func bind() {
          applyButton.buttonTap
              .bind(onNext: { [weak self] in
                  self?.applyButton.isSelected = true
                  self?.notApplyButton.isSelected = false
                  self?.applyState = true
              }).disposed(by: disposeBag)

          notApplyButton.buttonTap
            .bind(onNext: { [weak self] in
                  self?.notApplyButton.isSelected = true
                  self?.applyButton.isSelected = false
                  self?.applyState = false
              }).disposed(by: disposeBag)
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

}
