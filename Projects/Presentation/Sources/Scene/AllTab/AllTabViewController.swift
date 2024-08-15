import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import DesignSystem

public class AllTabViewController: BaseViewController<AllTabViewModel> {
    private let logoutRelay = PublishRelay<Void>()

    private lazy var navigationBar = PiCKMainNavigationBar(view: self)
    private let profileView = PiCKProfileView()
    private let helpSectionView = HelpSectionView()
    private let accountSectionView = AccountSectionView()

    public override func configureNavgationBarLayOutSubviews() {
        super.configureNavgationBarLayOutSubviews()
        
        navigationController?.isNavigationBarHidden = true
    }
    public override func bind() {
        let input = AllTabViewModel.Input(
            clickNoticeTab: helpSectionView.getSelectedItem(type: .notice).asObservable(),
            clickSelfStudyTab: helpSectionView.getSelectedItem(type: .selfStudy).asObservable(),
            clickBugReportTab: helpSectionView.getSelectedItem(type: .bugReport).asObservable(),
            clickMyPageTab: accountSectionView.getSelectedItem(type: .myPage),
            clickLogOutTab: logoutRelay.asObservable()
        )

        let output = viewModel.transform(input: input)

        self.accountSectionView.getSelectedItem(type: .logOut)
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                let vc = LogOutAlert(clickLogout: {
                    self?.logoutRelay.accept(())
                })
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                self?.present(vc, animated: true)
            })
            .disposed(by: disposeBag)
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
            $0.top.equalTo(navigationBar.snp.bottom).offset(24)
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
