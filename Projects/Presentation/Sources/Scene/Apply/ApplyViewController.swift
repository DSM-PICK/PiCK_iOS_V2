import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import DesignSystem

public class ApplyViewController: BaseViewController<ApplyViewModel> {
    
    private let navigationBar = PiCKMainNavigationBar()
    private let applyLabel = UILabel().then {
        $0.text = "신청"
        $0.textColor = .modeBlack
        $0.font = .heading4
    }
    private let tabStackView = PiCKApplyStackView()
//    private lazy var tabStackView = UIStackView(arrangedSubviews: [
//        weekendMealTab,
//        classRoomTab,
//        outingTab,
//        earlyLeaveTab
//    ]).then {
//        $0.axis = .vertical
//        $0.spacing = 20
//        $0.distribution = .fillEqually
//    }
    
    
    public override func attribute() {
        super.attribute()
        
        view.backgroundColor = .background
        navigationController?.isNavigationBarHidden = true
    }
    public override func bindAction() {
        navigationBar.viewSettingButtonTap
            .bind(onNext: { [weak self] in
                let vc = PiCKBottomSheetAlert(type: .viewType)

                let customDetents = UISheetPresentationController.Detent.custom(
                    identifier: .init("sheetHeight")
                ) { _ in
                    return 252
                }

                if let sheet = vc.sheetPresentationController {
                    sheet.detents = [customDetents]
                }
                self?.present(vc, animated: true)
            }).disposed(by: disposeBag)
        navigationBar.displayModeButtonTap
            .bind(onNext: { [weak self] in
                let vc = PiCKBottomSheetAlert(type: .displayMode)

                vc.clickModeButton = { data in
                    UserDefaultsManager.shared.set(to: data, forKey: .displayMode)
                    let rawValue = UserDefaultsManager.shared.get(forKey: .displayMode) as! Int
                    UIView.transition(with: self!.view, duration: 0.7, options: .transitionCrossDissolve) {
                        self?.view.window?.overrideUserInterfaceStyle = UIUserInterfaceStyle(rawValue: rawValue) ?? .unspecified
                    }
                }
                
                let customDetents = UISheetPresentationController.Detent.custom(
                    identifier: .init("sheetHeight")
                ) { _ in
                    return 228
                }

                if let sheet = vc.sheetPresentationController {
                    sheet.detents = [customDetents]
                }
                self?.present(vc, animated: true)
            }).disposed(by: disposeBag)
    }
    
    public override func addView() {
        [
            navigationBar,
            applyLabel,
            tabStackView
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
        tabStackView.snp.makeConstraints {
            $0.top.equalTo(applyLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(24)

        }
    }

}
