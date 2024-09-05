import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import DesignSystem

public class CustomSettingViewController: BaseViewController<CustomSettingViewModel> {
    private lazy var tabArray = [
        homeSettingTabView,
        applyAlertSettingTabView
    ]

    private let titleLabel = PiCKLabel(
        text: "커스텀",
        textColor: .modeBlack,
        font: .heading4
    )
    private let subTitleLabel = PiCKLabel(
        text: "픽은 커스텀할 수 있어요!",
        textColor: .gray500,
        font: .body1
    )
    private let homeSettingTabView = PiCKTabView(
        title: "메인페이지 설정",
        explain: "''",
        icon: .alert
    )
    private lazy var applyAlertSettingTabView = PiCKTabView(
        title: "신청 단위 설정",
        explain: "",
        icon: .alert
    )
    private lazy var tabStackView = UIStackView(arrangedSubviews: tabArray).then {
        $0.axis = .vertical
        $0.spacing = 20
    }

    public override func bind() {
        let input = CustomSettingViewModel.Input(
            viewWillAppear: viewWillAppearRelay.asObservable(),
            clickHomeSetting: homeSettingTabView.clickActionButton.asObservable(),
            clickApplyAlertSetting: applyAlertSettingTabView.clickActionButton.asObservable()
        )
        let output = viewModel.transform(input: input)

        output.tabViewText.asObservable()
            .bind { text in
                self.homeSettingTabView.setup(
                    explain: text.0,
                    buttonText: text.1
                )
            }.disposed(by: disposeBag)

        homeSettingTabView.rx.tapGesture()
            .bind { _ in
                self.toggleTabAction(selectedTab: self.homeSettingTabView)
            }.disposed(by: disposeBag)

        applyAlertSettingTabView.rx.tapGesture()
            .bind { _ in
                self.toggleTabAction(selectedTab: self.applyAlertSettingTabView)
            }.disposed(by: disposeBag)
    }

    public override func addView() {
        [
            titleLabel,
            subTitleLabel,
            tabStackView
        ].forEach { view.addSubview($0) }
    }

    public override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview().inset(24)
        }
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(24)
        }
        tabStackView.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
    }

    private func toggleTabAction(selectedTab: PiCKTabView) {
        self.tabArray.forEach { tab in
            if tab.isOpen == true && tab != selectedTab {
                tab.isOpen = false
            }
        }
    }

}