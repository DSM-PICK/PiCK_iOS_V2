import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import FSCalendar

import Core

public class PiCKCalendarView: BaseView, FSCalendarDelegate, FSCalendarDataSource {
    private var calendarType: CalendarType = .schoolMealWeek

    private var clickDate: (Date) -> Void

    public var clickTopToggleButton: ControlEvent<Void> {
        return topToggleButton.buttonTap
    }
    public var clickBottomToggleButton: ControlEvent<Void> {
        return bottomToggleButton.buttonTap
    }

    private var dateSelectRelay = PublishRelay<Void>()

    private let topToggleButton = PiCKImageButton(
        image: .topArrow,
        imageColor: .main500
    )
    private lazy var calendarHeaderLabel = PiCKLabel(
        text: calendarView.currentPage.toString(type: .yearsAndMonthKor),
        textColor: .modeBlack,
        font: .pickFont(.label1)
    )
    private let previousButton = PiCKImageButton(
        image: .leftArrow,
        imageColor: .modeBlack
    )
    private let nextButton = PiCKImageButton(
        image: .rightArrow,
        imageColor: .modeBlack
    )
    private lazy var headerStackView = UIStackView(arrangedSubviews: [
        previousButton,
        calendarHeaderLabel,
        nextButton
    ]).then {
        $0.axis = .horizontal
        $0.spacing = 12
    }

    private lazy var calendarView = FSCalendar().then {
        $0.backgroundColor = .clear

        $0.calendarHeaderView.isHidden = true
        $0.locale = Locale(identifier: "ko_KR")
        $0.appearance.weekdayTextColor = .modeBlack
        $0.appearance.weekdayFont = .pickFont(.label1)
        $0.placeholderType = .none
        $0.appearance.titleDefaultColor = .modeBlack
        $0.appearance.titleSelectionColor = .modeBlack
        $0.appearance.titleFont = .pickFont(.caption1)
        $0.appearance.selectionColor = .background
        $0.appearance.borderSelectionColor = .main100
        $0.appearance.titleTodayColor = .modeBlack
        $0.appearance.titleSelectionColor = .modeBlack
        $0.appearance.todayColor = .main100
        $0.appearance.todaySelectionColor = .main100
        $0.appearance.eventDefaultColor = .main500
        $0.appearance.eventSelectionColor = .main500
        $0.appearance.eventOffset = .init(x: 0, y: 3.0)

        $0.delegate = self
        $0.dataSource = self
    }
    private let bottomToggleButton = PiCKImageButton(
        image: .bottomArrow,
        imageColor: .main500
    )

    public func setupDate(
        date: Date
    ) {
        self.calendarView.setCurrentPage(date, animated: true)
        self.calendarView.select(date)
    }

    public init(
        calnedarType: CalendarType,
        clickDate: @escaping (Date) -> Void
    ) {
        self.clickDate = clickDate
        self.calendarType = calnedarType
        super.init(frame: .zero)

        setupCalendar(type: calnedarType)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func bind() {
        previousButton.rx.tap
            .bind { [weak self] in
                self?.moveCalendar(byMonths: -1)
            }.disposed(by: disposeBag)

        nextButton.rx.tap
            .bind { [weak self] in
                self?.moveCalendar(byMonths: 1)
            }.disposed(by: disposeBag)
    }

    public override func layout() {
        [
            topToggleButton,
            calendarView,
            bottomToggleButton
        ].forEach { self.addSubview($0) }
        calendarView.addSubview(headerStackView)

        switch calendarType {
        case .schoolMealWeek, .schoolMealMonth:
            calendarView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            headerStackView.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalToSuperview()
            }
            bottomToggleButton.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(calendarView.calendarWeekdayView.snp.bottom).offset(40)
            }
        case .selfStudyWeek, .selfStudyMonth:
            topToggleButton.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalToSuperview().inset(10)
            }
            calendarView.snp.makeConstraints {
                $0.top.equalTo(topToggleButton.snp.bottom).offset(10)
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalTo(self.safeAreaLayoutGuide)
            }
            headerStackView.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalToSuperview()
            }
        }
    }

    private func moveCalendar(byMonths months: Int) {
        let currentPage = calendarView.currentPage
        if let targetMonth = Calendar.current.date(byAdding: .month, value: months, to: currentPage) {
            calendarView.setCurrentPage(targetMonth, animated: true)
        }
    }

    private func setupCalendar(type: CalendarType) {
        switch type {
        case .schoolMealWeek:
            self.calendarView.scope = .week
            self.previousButton.isHidden = true
            self.nextButton.isHidden = true
            self.topToggleButton.isHidden = true

        case .schoolMealMonth:
            calendarView.scope = .month
            self.bottomToggleButton.isHidden = true
            self.topToggleButton.isHidden = true

        case .selfStudyWeek:
            self.calendarView.scope = .week
            self.previousButton.isHidden = true
            self.nextButton.isHidden = true
            self.bottomToggleButton.isHidden = true

        case .selfStudyMonth:
            self.calendarView.scope = .month
            self.topToggleButton.isHidden = true
            self.bottomToggleButton.isHidden = true
        }
        self.layout()
    }

}

extension PiCKCalendarView {
    public func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        self.calendarHeaderLabel.text = calendar.currentPage.toString(type: .yearsAndMonthKor)
    }

    public func calendar(
        _ calendar: FSCalendar,
        didSelect date: Date, at monthPosition: FSCalendarMonthPosition
    ) {
        self.clickDate(date)
    }

}
