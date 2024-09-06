import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa
import RxGesture

import Core
import DesignSystem

public class PiCKApplyStackView: BaseView {
    public var clickWeekendMealTab: ControlEvent<Void> {
        return weekendMealApplyTab.clickActionButton
    }
    public var clickClassroomMoveTab: ControlEvent<Void> {
        return classroomMoveApplyTab.clickActionButton
    }
    public var clickOutingTab: ControlEvent<Void> {
        return outingApplyTab.clickActionButton
    }
    public var clickEarlyLeaveTab: ControlEvent<Void> {
        return earlyLeaveApplyTab.clickActionButton
    }

    private let weekendMealApplyTab = PiCKTabView(
        title: "주말 급식 신청",
        explain: "지금은 주말급식 신청 기간입니다.\n주말 급식 신청은 매달 한 번 한정된 기간에 합니다.",
        icon: .weekendMeal
    )
    private let classroomMoveApplyTab = PiCKTabView(
        title: "교실 이동 신청",
        explain: "선생님께서 수락하시기 전엔 이동할 수 없습니다.\n수락 후 이동하시기 바랍니다.",
        icon: .classroomMove
    )
    private let outingApplyTab = PiCKTabView(
        title: "외출 신청",
        explain: "선생님께 미리 수락을 받은 뒤 신청합니다.",
        icon: .outing
    )
    private let earlyLeaveApplyTab = PiCKTabView(
        title: "조기 귀가 신청",
        explain: "선생님께 미리 수락을 받은 뒤 신청합니다.",
        icon: .earlyLeave
    )
    private lazy var backStackView = UIStackView(arrangedSubviews: [
        weekendMealApplyTab,
        classroomMoveApplyTab,
        outingApplyTab,
        earlyLeaveApplyTab
    ]).then {
        $0.axis = .vertical
        $0.spacing = 20
        $0.isLayoutMarginsRelativeArrangement = true
    }

    public override func bind() {
        weekendMealApplyTab.rx.tapGesture()
            .when(.recognized)
            .bind { _ in
                self.toggleTabAction(selectedTab: self.weekendMealApplyTab)
            }.disposed(by: disposeBag)

        classroomMoveApplyTab.rx.tapGesture()
            .when(.recognized)
            .bind { _ in
                self.toggleTabAction(selectedTab: self.classroomMoveApplyTab)
            }.disposed(by: disposeBag)

        outingApplyTab.rx.tapGesture()
            .when(.recognized)
            .bind { _ in
                self.toggleTabAction(selectedTab: self.outingApplyTab)
            }.disposed(by: disposeBag)

        earlyLeaveApplyTab.rx.tapGesture()
            .when(.recognized)
            .bind { _ in
                self.toggleTabAction(selectedTab: self.earlyLeaveApplyTab)
            }.disposed(by: disposeBag)
    }
    public override func layout() {
        self.addSubview(backStackView)
        
        backStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func toggleTabAction(selectedTab: PiCKTabView) {
        let array = [
            weekendMealApplyTab,
            classroomMoveApplyTab,
            outingApplyTab,
            earlyLeaveApplyTab
        ]

        array.forEach { tab in
            if tab.isOpen == true && tab != selectedTab {
                tab.isOpen = false
            }
        }
    }

}
