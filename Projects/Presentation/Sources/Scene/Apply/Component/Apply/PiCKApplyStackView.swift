import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import DesignSystem

public class PiCKApplyStackView: BaseStackView {
    
//    private lazy var tabsArray = [
//        weekendMealTab,
//        classRoomTab,
//        outingTab,
//        earlyLeaveTab
//    ]
    
//    private let weekendMealTab = PiCKApplyView(
//        icon: .weekendMeal,
//        title: "주말 급식 신청",
//        explain: "지금은 주말급식 신청 기간입니다.\n주말 급식 신청은 매달 한 번 한정된 기간에 합니다."
//    )
//    private let classRoomTab = PiCKApplyView(
//        icon: .classRoomMove,
//        title: "교실 이동 신청",
//        explain: "선생님께서 수락하시기 전엔 이동할 수 없습니다.\n수락 후 이동하시기 바랍니다."
//    )
//    private let outingTab = PiCKApplyView(
//        icon: .outing,
//        title: "외출 신청",
//        explain: "선생님께 미리 수락을 받은 뒤 신청합니다."
//    )
//    private let earlyLeaveTab = PiCKApplyView(
//        icon: .earlyLeave,
//        title: "조기 귀가 신청",
//        explain: "선생님께 미리 수락을 받은 뒤 신청합니다."
//    )

    public override func attribute() {
        self.axis = .vertical
        self.spacing = 20
        self.distribution = .fill
    }

    public override func bind() {
        /*하나의 탭이 클릭되면 그 탭의 isclick이 true로 바뀜
         그 후 그 탭이 클릭된다면 그 탭을 false로,
         다른 탭이 클릭된다면 true였던 탭을 false로,
         클릭된 탭을 true로
         */
    }

    public override func layout() {
//        tabsArray.forEach { self.addArrangedSubview($0) }
//
//        self.snp.makeConstraints {
//            $0.height.equalTo(200)
//        }
    }

}
