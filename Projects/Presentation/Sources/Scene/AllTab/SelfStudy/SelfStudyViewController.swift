import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import Domain
import DesignSystem

public class SelfStudyViewController: BaseViewController<SelfStudyViewModel> {
    private let loadSelfStudyRelay = PublishRelay<String>()

    private let todayDate = Date()

    private lazy var titleLabel = PiCKLabel(
        text: "\(todayDate.toString(type: .monthAndDayKor)),\n오늘의 자습 감독 선생님입니다",
        textColor: .modeBlack,
        font: .heading4,
        numberOfLines: 0
    ).then{
        $0.changePointColor(targetString: "오늘의 자습 감독", color: .main500)
    }

    private lazy var floorStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 32
        $0.distribution = .fillEqually
    }
    private lazy var teacherStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 32
        $0.distribution = .fillEqually
    }
    private let emptySelfStudyLabel = PiCKLabel(
        text: "등록된 자습 감독 선생님이 없습니다.",
        textColor: .modeBlack,
        font: .body1,
        isHidden: true
    )
    private lazy var calendarView = PiCKCalendarView(
        calnedarType: .selfStudyWeek,
        clickDate: { date in
            self.loadSelfStudyRelay.accept(date.toString(type: .fullDate))
            if date.toString(type: .fullDate) == self.todayDate.toString(type: .fullDate) {
                self.titleLabel.text = "\(date.toString(type: .monthAndDayKor)),\n오늘의 자습 감독 선생님입니다"
                self.titleLabel.changePointColor(targetString: "오늘의 자습 감독", color: .main500)
            } else {
                self.titleLabel.text = "\(date.toString(type: .monthAndDayKor))의\n자습 감독 선생님입니다"
                self.titleLabel.changePointColor(targetString: "\(date.toString(type: .monthAndDayKor))의", color: .main500)
            }
        }
    )

    public override func attribute() {
        super.attribute()

        navigationTitleText = "자습 감독 선생님 확인"
    }

    public override func bindAction() {
        self.loadSelfStudyRelay.accept(todayDate.toString(type: .fullDate))
    }
    public override func bind() {
        let input = SelfStudyViewModel.Input(
            selfStudyDate: loadSelfStudyRelay.asObservable()
        )
        let output = viewModel.transform(input: input)

        output.selfStudyData.asObservable()
            .subscribe(onNext: { [weak self] data in
                let isEmpty = data.isEmpty

                self?.floorStackView.isHidden = isEmpty
                self?.teacherStackView.isHidden = isEmpty
                self?.emptySelfStudyLabel.isHidden = !isEmpty

                self?.setupSelftStudyLabel(data: data)
            }).disposed(by: disposeBag)

        self.calendarView.clickTopToggleButton
            .subscribe(onNext: { [weak self] in
                let alert = PiCKCalendarAlert(
                    calendarType: .selfStudyMonth,
                    clickDate: { date in
                        self?.calendarView.setupDate(date: date)
                        self?.loadSelfStudyRelay.accept(date.toString(type: .fullDate))

                        self?.updateTitleLabel(with: date)
                    }
                )
                alert.modalTransitionStyle = .crossDissolve
                alert.modalPresentationStyle = .overFullScreen
                self?.present(alert, animated: true)
            }).disposed(by: disposeBag)
    }
    public override func addView() {
        [
            titleLabel,
            floorStackView,
            teacherStackView,
            emptySelfStudyLabel,
            calendarView
        ].forEach { view.addSubview($0) }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(52)
            $0.leading.equalToSuperview().inset(24)
        }
        floorStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
            $0.leading.equalToSuperview().inset(24)
        }
        teacherStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
            $0.trailing.equalToSuperview().inset(24)
        }
        emptySelfStudyLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        calendarView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(170)
            $0.height.equalTo(350)
        }
    }

    private func setupSelftStudyLabel(data: SelfStudyEntity) {
        floorStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for floor in data {
            let floorLabel = AllTabLabel(
                type: .contentTitleLabel,
                text: "\(floor.floor)층"
            )
            floorStackView.addArrangedSubview(floorLabel)
        }

        teacherStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for teacher in data {
            let teacherLabel = AllTabLabel(
                type: .contentLabel,
                text: "\(teacher.teacherName) 선생님"
            )
            teacherStackView.addArrangedSubview(teacherLabel)
        }
    }

    private func updateTitleLabel(with date: Date) {
        if date.toString(type: .fullDate) == self.todayDate.toString(type: .fullDate) {
            self.titleLabel.text = "\(date.toString(type: .monthAndDayKor)),\n오늘의 자습 감독 선생님입니다"
            self.titleLabel.changePointColor(targetString: "오늘의 자습 감독", color: .main500)
        } else {
            self.titleLabel.text = "\(date.toString(type: .monthAndDayKor))의\n자습 감독 선생님입니다"
            self.titleLabel.changePointColor(targetString: "\(date.toString(type: .monthAndDayKor))의", color: .main500)
        }
    }

}
