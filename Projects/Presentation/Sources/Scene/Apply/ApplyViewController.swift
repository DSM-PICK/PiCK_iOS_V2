import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import DesignSystem

public class ApplyViewController: BaseViewController<ApplyViewModel> {
    
    private lazy var navigationBar = PiCKMainNavigationBar(view: self)
    private let applyLabel = PiCKLabel(text: "신청", textColor: .modeBlack, font: .heading4)
//    private let tabStackView = PiCKApplyStackView()
    private let weekendMealTab = PiCKApplyView(
        icon: .weekendMeal,
        title: "주말 급식 신청",
        explain: "지금은 주말급식 신청 기간입니다.\n주말 급식 신청은 매달 한 번 한정된 기간에 합니다."
    )
    private let classRoomTab = PiCKApplyView(
        icon: .classRoomMove,
        title: "교실 이동 신청",
        explain: "선생님께서 수락하시기 전엔 이동할 수 없습니다.\n수락 후 이동하시기 바랍니다."
    )
    private let outingTab = PiCKApplyView(
        icon: .outing,
        title: "외출 신청",
        explain: "선생님께 미리 수락을 받은 뒤 신청합니다."
    )
    private let earlyLeaveTab = PiCKApplyView(
        icon: .earlyLeave,
        title: "조기 귀가 신청",
        explain: "선생님께 미리 수락을 받은 뒤 신청합니다."
    )

    public override func attribute() {
        super.attribute()
        
        view.backgroundColor = .background
    }
    public override func configureNavgationBarLayOutSubviews() {
        super.configureNavgationBarLayOutSubviews()

        navigationController?.isNavigationBarHidden = true
    }
    public override func addView() {
        [
            navigationBar,
            applyLabel,
//            tabStackView
            weekendMealTab
        ].forEach { view.addSubview($0) }
    }
    public override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        applyLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(24)
        }
//        tabStackView.snp.makeConstraints {
//            $0.top.equalTo(applyLabel.snp.bottom).offset(20)
//            $0.leading.trailing.equalToSuperview().inset(24)
//        }
        weekendMealTab.snp.makeConstraints {
            $0.top.equalTo(applyLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
    }

}
