import Foundation

import RxSwift

import Core

public protocol ScheduleRepository {
    func fetchMonthAcademicSchedule(year: String, month: String) -> Single<AcademicScheduleEntity>
    func fetchTodayTimeTable() -> Single<TimeTableEntity>
    func fetchWeekTimeTable() -> Single<WeekTimeTableEntity>
}
