import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import FSCalendar

import Core
import Domain
import DesignSystem

public class AcademicScheduleCalneder: BaseView, FSCalendarDelegate, FSCalendarDelegateAppearance, FSCalendarDataSource {
    public var clickDate: (Date) -> Void

    private lazy var monthAcademicScheduleData = BehaviorRelay<AcademicScheduleEntity>(value: [])

    private lazy var calendar = FSCalendar().then {
        $0.scope = .month
        $0.backgroundColor = .background

        //MARK: 헤더 설정
        $0.locale = Locale(identifier: "ko_KR")
        $0.appearance.weekdayTextColor = .modeBlack
        $0.appearance.weekdayFont = .label1
        $0.appearance.headerTitleColor = .modeBlack
        $0.appearance.headerTitleFont = .label1
        $0.appearance.headerMinimumDissolvedAlpha = 0.0
        //이전, 이후 달 안보이게
        $0.placeholderType = .none
        $0.headerHeight = 40
        $0.appearance.headerDateFormat = "yyyy년 MM월"
        //MARK: 셀 설정
        //선택한 셀 텍스트색
        $0.appearance.titleSelectionColor = .modeBlack
        //셀 폰트
        $0.appearance.titleFont = .caption1
        //선택한 셀 배경색
        $0.appearance.selectionColor = .background
        //선택한 셀 borderColor
        $0.appearance.borderSelectionColor = .main100
        //오늘 날짜 셀 텍스트색
        $0.appearance.titleTodayColor = .modeBlack
        //오늘 날짜 셀 배경색
        $0.appearance.todayColor = .main100
        //오늘 날짜 선택시 배경색
        $0.appearance.todaySelectionColor = .main100

        //밑점 색상
        $0.appearance.eventDefaultColor = .main500
        $0.appearance.eventSelectionColor = .main500

        //delegate 설정
        $0.delegate = self
        $0.dataSource = self
    }
    private let previousButton = PiCKImageButton(image: .leftArrow, imageColor: .modeBlack)
    private let nextButton = PiCKImageButton(image: .rightArrow, imageColor: .modeBlack)

    public func setup(
        monthAcademicSchedule: AcademicScheduleEntity
    ) {
        self.monthAcademicScheduleData.accept(monthAcademicSchedule)
    }

    public init(clickDate: @escaping (Date) -> Void) {
        self.clickDate = clickDate
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func bind() {
        previousButton.rx.tap
              .bind(onNext: { [weak self] in
                  self?.moveCalendar(byMonths: -1)
              }).disposed(by: disposeBag)

          nextButton.rx.tap
              .bind(onNext: { [weak self] in
                  self?.moveCalendar(byMonths: 1)
              }).disposed(by: disposeBag)
    }

    private func moveCalendar(byMonths months: Int) {
        let currentPage = calendar.currentPage
        if let targetMonth = Calendar.current.date(byAdding: .month, value: months, to: currentPage) {
            calendar.setCurrentPage(targetMonth, animated: true)
        }
    }

    public override func layout() {
        self.addSubview(calendar)
        [
            previousButton,
            nextButton
        ].forEach { calendar.addSubview($0) }

        calendar.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        previousButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(5)
            $0.trailing.equalTo(calendar.calendarHeaderView.snp.leading).offset(30)
        }
        nextButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(5)
            $0.leading.equalTo(calendar.calendarHeaderView.snp.trailing).offset(-30)
        }
    }
    func getDateEventArray() -> [Date] {
        var dd: [Date] = []
        var event: [String] = []

        for i in monthAcademicScheduleData.value {
            event.append("\(i.month)-\(i.day)")
        }

        for i in event {
            dd.append(i.toDate(type: .fullDate))
        }

        print("이거 \(dd)")
        print("요거 \(monthAcademicScheduleData.value)")
        return dd
    }

}

extension AcademicScheduleCalneder {
    public func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.clickDate(date)
    }

    public func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if self.getDateEventArray().contains(date) {
            return 1
        }
        return 0
    }

}
