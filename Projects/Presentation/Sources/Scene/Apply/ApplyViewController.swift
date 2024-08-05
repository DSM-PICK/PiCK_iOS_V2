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
    private let applyTabView = PiCKApplyStackView()

    public override func attribute() {
        super.attribute()
        
        view.backgroundColor = .background
    }
    public override func configureNavgationBarLayOutSubviews() {
        super.configureNavgationBarLayOutSubviews()

        navigationController?.isNavigationBarHidden = true
    }
    public override func bind() {
        let input = ApplyViewModel.Input(
            clickWeekendMealButton: applyTabView.clickOutingTab.asObservable(),
            clickClassRoomMoveButton: applyTabView.clickOutingTab.asObservable(),
            clickOutingButton: applyTabView.clickOutingTab.asObservable(),
            clickEarlyLeaveButton: applyTabView.clickEarlyLeaveTab.asObservable()
        )
        let output = viewModel.transform(input: input)
    }
    public override func addView() {
        [
            navigationBar,
            applyLabel,
            applyTabView
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
        applyTabView.snp.makeConstraints {
            $0.top.equalTo(applyLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
    }

}
