import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import FSCalendar

import Core
import Domain
import DesignSystem

public class AcademicScheduleCalneder: BaseView, FSCalendarDelegate, FSCalendarDataSource {
    public var clickYearAndMonth: (Date, Date) -> Void
    public var clickDate: (Date) -> Void

    private var dateSelectRelay = PublishRelay<Void>()
    private var monthAcademicScheduleData = BehaviorRelay<AcademicScheduleEntity>(value: [])

    private lazy var calendarHeaderLabel = PiCKLabel(
        text: calendarView.currentPage.toString(type: .yearsAndMonthKor),
        textColor: .modeBlack,
        font: .label1
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
        $0.scope = .month
        $0.backgroundColor = .background
        $0.calendarHeaderView.isHidden = true

        $0.locale = Locale(identifier: "ko_KR")
        $0.appearance.weekdayTextColor = .modeBlack
        $0.appearance.weekdayFont = .label1
        $0.placeholderType = .none
        $0.appearance.titleDefaultColor = .modeBlack
        $0.appearance.titleSelectionColor = .modeBlack
        $0.appearance.titleFont = .caption1
        $0.appearance.selectionColor = .background
        $0.appearance.borderSelectionColor = .main100
        $0.appearance.titleTodayColor = .modeBlack
        $0.appearance.todayColor = .main100
        $0.appearance.todaySelectionColor = .main100
        $0.appearance.eventDefaultColor = .main500
        $0.appearance.eventSelectionColor = .main500
        $0.appearance.eventOffset = .init(x: 0, y: 3.0)

        $0.delegate = self
        $0.dataSource = self
    }

    public func setup(
        monthAcademicSchedule: AcademicScheduleEntity
    ) {
        self.monthAcademicScheduleData.accept(monthAcademicSchedule)
        self.calendarView.reloadData()
    }

    public init(
        clickYearAndMonth: @escaping (Date, Date) -> Void,
        clickDate: @escaping (Date) -> Void
    ) {
        self.clickYearAndMonth = clickYearAndMonth
        self.clickDate = clickDate
        super.init(frame: .zero)

        let todayDate = Date()
        clickDate(todayDate)
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
        self.addSubview(calendarView)
        calendarView.addSubview(headerStackView)

        calendarView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        headerStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
        }
    }

    private func moveCalendar(byMonths months: Int) {
        let currentPage = calendarView.currentPage
        if let targetMonth = Calendar.current.date(byAdding: .month, value: months, to: currentPage) {
            calendarView.setCurrentPage(targetMonth, animated: true)
            notifyYearAndMonthChange(date: targetMonth)
        }
    }

    private func notifyYearAndMonthChange(date: Date) {
        let calendar = Calendar.current
        if let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date)),
           let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth) {
            clickYearAndMonth(startOfMonth, endOfMonth)
        }
    }

    private func getDateEventArray() -> [Date] {
        var dateArray: [Date] = []
        let currentYear = Calendar.current.component(.year, from: Date())

        for date in monthAcademicScheduleData.value {
            dateArray.append("\(currentYear)-\(date.month)-\(date.day)".toDate(type: .fullDate))
        }

        return dateArray
    }

}

extension AcademicScheduleCalneder {
    public func calendarCurrentPageDidChange(
        _ calendar: FSCalendar
    ) {
        self.calendarHeaderLabel.text = calendar.currentPage.toString(type: .yearsAndMonthKor)
        notifyYearAndMonthChange(date: calendar.currentPage)
    }

    public func calendar(
        _ calendar: FSCalendar,
        didSelect date: Date,
        at monthPosition: FSCalendarMonthPosition
    ) {
        self.clickDate(date)
    }

    public func calendar(
        _ calendar: FSCalendar,
        numberOfEventsFor date: Date
    ) -> Int {
        return self.getDateEventArray().contains(date) ? 1 : 0
    }

}
