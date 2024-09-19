import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import DesignSystem

public class NotificationViewController: BaseViewController<NotificationViewModel> {
    private lazy var switchViewArray = [
        outingStatusNotificationSwitchView,
        classroomStatusSwitchView,
        noticeNotificationSwitchView,
        weekendMealNotificationSwitchView
    ]

    private let allNotificationSwitchView = NotificationSwitchView(title: "전체 알림")
    private let lineView = UIView().then {
        $0.backgroundColor = .gray50
    }
    private let titleLabel = PiCKLabel(
        text: "맞춤 알림",
        textColor: .modeBlack,
        font: .heading4
    )
    private let subTitleLabel = PiCKLabel(
        text: "원하시는 알림을 설정하면 원하는 알림만 보내드릴게요.",
        textColor: .gray500,
        font: .body1
    )
    private let outingStatusNotificationSwitchView = NotificationSwitchView(title: "외출 상태 변경")
    private let classroomStatusSwitchView = NotificationSwitchView(title: "교실 이동 상태 변경")
    private let noticeNotificationSwitchView = NotificationSwitchView(title: "새로운 공지 등록")
    private let weekendMealNotificationSwitchView = NotificationSwitchView(title: "주말 급식 신청기간")
    private lazy var switchStackView = UIStackView(arrangedSubviews: [
        outingStatusNotificationSwitchView,
        classroomStatusSwitchView,
        noticeNotificationSwitchView,
        weekendMealNotificationSwitchView
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
        let input = NotificationViewModel.Input(
            viewWillAppear: viewWillAppearRelay.asObservable(),
            outingStatus: outingStatusNotificationSwitchView.clickSwitchButton.asObservable(),
            classroomStatus: classroomStatusSwitchView.clickSwitchButton.asObservable(),
            newNoticeStatus: noticeNotificationSwitchView.clickSwitchButton.asObservable(),
            weekendMealStatus: weekendMealNotificationSwitchView.clickSwitchButton.asObservable()
        )
        let output = viewModel.transform(input: input)

        output.notificationStatus.asObservable()
            .withUnretained(self)
            .bind { owner, status in
                let isSubscribedArray = status.subscribeTopicResponse.map { $0.isSubscribed }

                for (index, switchView) in owner.switchViewArray.enumerated() {
                    switchView.setup(isOn: isSubscribedArray[index])
                }

                let allSubscribed = isSubscribedArray.allSatisfy { $0 }
                owner.allNotificationSwitchView.setup(isOn: allSubscribed)
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

        outingStatusNotificationSwitchView.clickSwitchButton
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

        noticeNotificationSwitchView.clickSwitchButton
            .asObservable()
            .withUnretained(self)
            .bind { owner, _ in
                owner.toggleButton()
            }.disposed(by: disposeBag)

        weekendMealNotificationSwitchView.clickSwitchButton
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
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(28)
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
            outingStatusNotificationSwitchView.switchIsOn &&
            classroomStatusSwitchView.switchIsOn &&
            noticeNotificationSwitchView.switchIsOn &&
            weekendMealNotificationSwitchView.switchIsOn
        ) == true {
            self.allNotificationSwitchView.setup(isOn: true)
        } else {
            self.allNotificationSwitchView.setup(isOn: false)
        }
    }

}
