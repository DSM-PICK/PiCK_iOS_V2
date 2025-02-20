import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import DesignSystem

public class NotificationSettingViewController: BaseViewController<NotificationSettingViewModel> {
    private lazy var switchViewArray = [
        outingStatusSwitchView,
        classroomStatusSwitchView,
        noticeSwitchView,
        weekendMealSwitchView
    ]

    private let allNotificationSwitchView = NotificationSwitchView(title: "전체 알림")
    private let lineView = UIView().then {
        $0.backgroundColor = .gray50
    }
    private let titleLabel = PiCKLabel(
        text: "맞춤 알림",
        textColor: .modeBlack,
        font: .pickFont(.heading4)
    )
    private let subTitleLabel = PiCKLabel(
        text: "원하시는 알림을 설정하면 원하는 알림만 보내드릴게요.",
        textColor: .gray500,
        font: .pickFont(.body1)
    )
    private let outingStatusSwitchView = NotificationSwitchView(title: "외출 상태 변경")
    private let classroomStatusSwitchView = NotificationSwitchView(title: "교실 이동 상태 변경")
    private let noticeSwitchView = NotificationSwitchView(title: "새로운 공지 등록")
    private let weekendMealSwitchView = NotificationSwitchView(title: "주말 급식 신청기간")
    private lazy var switchStackView = UIStackView(arrangedSubviews: [
        outingStatusSwitchView,
        classroomStatusSwitchView,
        noticeSwitchView,
        weekendMealSwitchView
    ]).then {
        $0.axis = .vertical
        $0.spacing = 12
        $0.distribution = .fillEqually
    }

    public override func attribute() {
        super.attribute()

        navigationTitleText = "알림 설정"
    }

    public override func bind() {
        let input = NotificationSettingViewModel.Input(
            viewWillAppear: viewWillAppearRelay.asObservable(),
            allStatus: allNotificationSwitchView.clickSwitchButton.asObservable(),
            outingStatus: outingStatusSwitchView.clickSwitchButton.asObservable(),
            classroomStatus: classroomStatusSwitchView.clickSwitchButton.asObservable(),
            newNoticeStatus: noticeSwitchView.clickSwitchButton.asObservable(),
            weekendMealStatus: weekendMealSwitchView.clickSwitchButton.asObservable()
        )
        let output = viewModel.transform(input: input)

        output.allNotificationStatus
            .asObservable()
            .withUnretained(self)
            .bind { owner, isOn in
                owner.allNotificationSwitchView.setup(isOn: isOn)
            }.disposed(by: disposeBag)

        output.outingNotificationStatus
            .asObservable()
            .withUnretained(self)
            .bind { owner, isOn in
                owner.outingStatusSwitchView.setup(isOn: isOn)
            }.disposed(by: disposeBag)

        output.classroomNotificationStatus
            .asObservable()
            .withUnretained(self)
            .bind { owner, isOn in
                owner.classroomStatusSwitchView.setup(isOn: isOn)
            }.disposed(by: disposeBag)

        output.newNoticeNotificationStatus
            .asObservable()
            .withUnretained(self)
            .bind { owner, isOn in
                owner.noticeSwitchView.setup(isOn: isOn)
            }.disposed(by: disposeBag)

        output.weekendMealNotificationStatus
            .asObservable()
            .withUnretained(self)
            .bind { owner, isOn in
                owner.weekendMealSwitchView.setup(isOn: isOn)
            }.disposed(by: disposeBag)
    }
    public override func bindAction() {
        allNotificationSwitchView.clickSwitchButton
            .asObservable()
            .withUnretained(self)
            .bind { owner, isOn in
                owner.switchViewArray.forEach {
                    $0.setup(isOn: isOn)
                }
            }.disposed(by: disposeBag)

        outingStatusSwitchView.clickSwitchButton
            .asObservable()
            .withUnretained(self)
            .bind { owner, _ in
                owner.toggleButton()
            }.disposed(by: disposeBag)

        classroomStatusSwitchView.clickSwitchButton
            .asObservable()
            .withUnretained(self)
            .bind { owner, _ in
                owner.toggleButton()
            }.disposed(by: disposeBag)

        noticeSwitchView.clickSwitchButton
            .asObservable()
            .withUnretained(self)
            .bind { owner, _ in
                owner.toggleButton()
            }.disposed(by: disposeBag)

        weekendMealSwitchView.clickSwitchButton
            .asObservable()
            .withUnretained(self)
            .bind { owner, _ in
                owner.toggleButton()
            }.disposed(by: disposeBag)
    }

    public override func addView() {
        [
            allNotificationSwitchView,
            lineView,
            titleLabel,
            subTitleLabel,
            switchStackView
        ].forEach { view.addSubview($0) }
    }
    public override func setLayout() {
        allNotificationSwitchView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(28)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(64)
        }
        lineView.snp.makeConstraints {
            $0.top.equalTo(allNotificationSwitchView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(8)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(40)
            $0.leading.equalToSuperview().inset(24)
        }
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(24)
        }
        switchStackView.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(300)
        }
    }

    private func toggleButton() {
        if (
            outingStatusSwitchView.switchIsOn &&
            classroomStatusSwitchView.switchIsOn &&
            noticeSwitchView.switchIsOn &&
            weekendMealSwitchView.switchIsOn
        ) {
            self.allNotificationSwitchView.setup(isOn: true)
        } else {
            self.allNotificationSwitchView.setup(isOn: false)
        }
    }

}
