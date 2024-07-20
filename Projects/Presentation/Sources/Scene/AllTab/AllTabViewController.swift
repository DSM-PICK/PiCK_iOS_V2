import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import DesignSystem

public class AllTabViewController: BaseViewController<AllTabViewModel> {

    private let navigationBar = PiCKMainNavigationBar()
    private let profileView = PiCKProfileView()
    private let helpSectionView = HelpSectionView()
    private let accountSectionView = AccountSectionView()
    
    public override func attribute() {
        super.attribute()
        
        navigationController?.isNavigationBarHidden = true
    }
    public override func bind() {
        let input = AllTabViewModel.Input(
            clickNoticeTab: helpSectionView.getSelectedItem(type: .announcement).asObservable()
        )
        let output = viewModel.transform(input: input)
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
            profileView,
            helpSectionView,
            accountSectionView
        ].forEach { view.addSubview($0) }
    }
        
    public override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        profileView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(36)
            $0.leading.trailing.equalToSuperview()
        }
        helpSectionView.snp.makeConstraints {
            $0.top.equalTo(profileView.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        accountSectionView.snp.makeConstraints {
            $0.top.equalTo(helpSectionView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
    }

}
