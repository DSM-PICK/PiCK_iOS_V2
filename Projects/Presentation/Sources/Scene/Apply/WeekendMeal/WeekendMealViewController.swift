import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import DesignSystem

public class WeekendMealViewController: BaseViewController<WeekendMealViewModel> {
    private let titleLabel = PiCKLabel(text: "주말 급식", textColor: .modeBlack, font: .heading4)
    private let explainLabel = PiCKLabel(text: "신청 여부는 담임 선생님이 확인 후 영양사 선생님에게 전달돼요.", textColor: .gray500, font: .caption2)
    private let weekendMealApplyView = UIView().then {
        $0.backgroundColor = .green
        $0.layer.cornerRadius = 8
    }
    private lazy var currnetMonthWeekendMealApplyLabel = UILabel().then {
//        $0.text = "\(nextMonth?.toString(type: .month) ?? "Error") 주말 급식 신청"
        $0.text = "ㅓㄹ아ㅣㄴㄴ"
        $0.textColor = .black
        $0.font = .body3
    }
    private let applyButton = PiCKButton(type: .system).then {
        $0.setTitle("신청", for: .normal)
    }
    private let noApplyButton = PiCKButton(type: .system).then {
        $0.setTitle("미신청", for: .normal)
    }
    private let additionApplyLabel = UILabel().then {
        $0.text = "추가 신청"
        $0.textColor = .black
        $0.font = .subTitle1
    }

    public override func attribute() {
        super.attribute()
        
        navigationTitleText = "주말 급식 신청"
    }

    public override func addView() {
        [
            titleLabel,
            explainLabel
        ].forEach { view.addSubview($0) }
        [
            currnetMonthWeekendMealApplyLabel,
            applyButton,
            noApplyButton
        ].forEach { weekendMealApplyView.addSubview($0) }
        
    }
}
