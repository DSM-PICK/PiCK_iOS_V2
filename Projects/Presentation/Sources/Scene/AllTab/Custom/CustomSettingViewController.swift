import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa
import RxFlow

import Core
import DesignSystem

public class CustomSettingViewController: UIViewController, Stepper {
    public var steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()

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
        explain: "메인페이지에서 급식 또는 시간표를 볼 수 있어요!\n현재는 급식으로 설정되어 있어요.",
        icon: .alert,
        buttonText: "시간표로 보기"
    )
    private let applyAlertSettingTabView = PiCKTabView(
        title: "신청 단위 설정",
        explain: "픽에서 신청할 때 시간 또는 교시로 설정할 수 있어요!\n현재는 시간으로 설정되어 있어요.",
        icon: .alert,
        buttonText: "교시로 설정하기"
    )
    private lazy var tabStackView = UIStackView(arrangedSubviews: tabArray).then {
        $0.axis = .vertical
        $0.spacing = 20
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .background
        navigationController?.isNavigationBarHidden = false
        bind()
    }
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        layout()
    }

    private func bind() {
        homeSettingTabView.rx.tapGesture()
            .when(.recognized)
            .bind { _ in
                self.toggleTabAction(selectedTab: self.homeSettingTabView)
            }.disposed(by: disposeBag)

        applyAlertSettingTabView.rx.tapGesture()
            .when(.recognized)
            .bind { _ in
                self.toggleTabAction(selectedTab: self.applyAlertSettingTabView)
            }.disposed(by: disposeBag)
    }

    private func layout() {
        [
            titleLabel,
            subTitleLabel,
            tabStackView
        ].forEach { view.addSubview($0) }

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
