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
    private let mainView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 32
    }

    private lazy var navigationBar = PiCKMainNavigationBar(view: self)
    private let profileView = PiCKProfileView()
    private let helpSectionView = HelpSectionView()
    private let settingSectionView = SettingSectionView()
    private let accountSectionView = AccountSectionView()
    private lazy var sectionStackView = UIStackView(arrangedSubviews: [
        helpSectionView,
        settingSectionView,
        accountSectionView
    ]).then {
        $0.axis = .vertical
        $0.spacing = 24
        $0.isLayoutMarginsRelativeArrangement = true
    }

    public override func configureNavgationBarLayOutSubviews() {
        super.configureNavgationBarLayOutSubviews()

        navigationController?.isNavigationBarHidden = true
    }
    public override func bind() {
        let input = AllTabViewModel.Input(
            viewWillAppear: viewWillAppearRelay.asObservable(),
            clickSelfStudyTab: helpSectionView.getSelectedItem(type: .selfStudy).asObservable(),
            clickNoticeTab: helpSectionView.getSelectedItem(type: .notice).asObservable(),
            clickBugReportTab: helpSectionView.getSelectedItem(type: .bugReport).asObservable(),
            clickCutomTab: settingSectionView.getSelectedItem(type: .custom),
            clickNotificationSettingTab: settingSectionView.getSelectedItem(type: .notification),
            clickMyPageTab: accountSectionView.getSelectedItem(type: .myPage),
            clickLogOutTab: logoutRelay.asObservable()
        )

        let output = viewModel.transform(input: input)

        output.profileData.asObservable()
            .withUnretained(self)
            .bind { owner, profileData in
                let userInfoData = UserDefaultStorage.shared.get(forKey: .userInfoData) as? String

                owner.profileView.setup(
                    image: profileData.profile ?? "",
                    info: userInfoData ?? ""
                )
            }.disposed(by: disposeBag)

        accountSectionView
            .getSelectedItem(type: .logOut)
            .asObservable()
            .withUnretained(self)
            .bind { owner, _ in
                let alert = PiCKAlert(
                    titleText: "정말 로그아웃 하시겠습니까?",
                    explainText: "기기내 계정에서 로그아웃 할 수 있어요\n다음 이용 시에는 다시 로그인 해야합니다.",
                    type: .negative
                ) {
                    owner.logoutRelay.accept(())
                }
                alert.modalPresentationStyle = .overFullScreen
                alert.modalTransitionStyle = .crossDissolve
                owner.present(alert, animated: true)
            }.disposed(by: disposeBag)
    }

    public override func addView() {
        [
            navigationBar,
            scrollView
        ].forEach { view.addSubview($0) }

        scrollView.addSubview(contentView)
        contentView.addSubview(mainView)

        [
            profileView,
            sectionStackView
        ].forEach { mainView.addArrangedSubview($0) }
    }
    public override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }

        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(24)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        contentView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalTo(self.view)
        }
        mainView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
    }

}
