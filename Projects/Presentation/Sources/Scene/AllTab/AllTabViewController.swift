import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import DesignSystem

public class AllTabViewController: BaseViewController<AllTabViewModel> {
    private let logoutRelay = PublishRelay<Void>()

    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
    }
    private let contentView = UIView()
    private let mainView = UIView()

    private lazy var navigationBar = PiCKMainNavigationBar(view: self)
    private let profileView = PiCKProfileView()
    private let helpSectionView = HelpSectionView()
    private let settingSectionView = SettingSectionView()
    private let accountSectionView = AccountSectionView()
//    private lazy var sectionStackVeiw = UIStackView(arrangedSubviews: [
//        helpSectionView,
//        settingSectionView,
//        accountSectionView
//    ]).then {
//        $0.axis = .vertical
//        $0.spacing = 24
//    }
    public override func configureNavgationBarLayOutSubviews() {
        super.configureNavgationBarLayOutSubviews()
        
        navigationController?.isNavigationBarHidden = true
    }
    public override func bind() {
        let input = AllTabViewModel.Input(
            clickNoticeTab: helpSectionView.getSelectedItem(type: .notice).asObservable(),
            clickSelfStudyTab: helpSectionView.getSelectedItem(type: .selfStudy).asObservable(),
            clickBugReportTab: helpSectionView.getSelectedItem(type: .bugReport).asObservable(),
            clickCutomTab: settingSectionView.getSelectedItem(type: .custom),
            clickNotificationSettingTab: settingSectionView.getSelectedItem(type: .notificationSetting),
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
            scrollView
        ].forEach { view.addSubview($0) }

        scrollView.addSubview(contentView)
        contentView.addSubview(mainView)

        [
            helpSectionView,
            settingSectionView,
            accountSectionView
        ].forEach { mainView.addSubview($0) }
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

        scrollView.snp.makeConstraints {
            $0.top.equalTo(profileView.snp.bottom).offset(32)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        contentView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalTo(self.view)
        }
        mainView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(self.view.frame.height)
        }

        helpSectionView.snp.makeConstraints {
//            $0.top.equalTo(profileView.snp.bottom).offset(32)
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        settingSectionView.snp.makeConstraints {
            $0.top.equalTo(helpSectionView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        accountSectionView.snp.makeConstraints {
            $0.top.equalTo(settingSectionView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
    }

}
