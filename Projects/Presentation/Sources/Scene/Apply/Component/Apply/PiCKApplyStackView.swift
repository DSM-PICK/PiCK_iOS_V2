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
        return weekendMealApplyTab.clickApplyButton
    }
    public var clickClassRoomMoveTab: ControlEvent<Void> {
        return classroomMoveApplyTab.clickApplyButton
    }
    public var clickOutingTab: ControlEvent<Void> {
        return outingApplyTab.clickApplyButton
    }
    public var clickEarlyLeaveTab: ControlEvent<Void> {
        return earlyLeaveApplyTab.clickApplyButton
    }

    private let weekendMealApplyTab = PiCKApplyView(
        title: "주말 급식 신청",
        explain: "지금은 주말급식 신청 기간입니다.\n주말 급식 신청은 매달 한 번 한정된 기간에 합니다.",
        icon: .weekendMeal
    )
    private let classroomMoveApplyTab = PiCKApplyView(
        title: "교실 이동 신청",
        explain: "선생님께서 수락하시기 전엔 이동할 수 없습니다.\n수락 후 이동하시기 바랍니다.",
        icon: .classRoomMove
    )
    private let outingApplyTab = PiCKApplyView(
        title: "외출 신청",
        explain: "선생님께 미리 수락을 받은 뒤 신청합니다.",
        icon: .outing
    )
    private let earlyLeaveApplyTab = PiCKApplyView(
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

    public override func layout() {
        self.addSubview(backStackView)
        
        backStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

}
