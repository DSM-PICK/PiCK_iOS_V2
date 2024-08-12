import Foundation

import RxSwift

import Core

public protocol ScheduleRepository {
    func fetchMonthAcademicSchedule(request: ScheduleRequestParams) -> Single<AcademicScheduleEntity>
    func fetchTodayTimeTable() -> Single<TimeTableEntity>
    func fetchWeekTimeTable() -> Single<WeekTimeTableEntity>
}