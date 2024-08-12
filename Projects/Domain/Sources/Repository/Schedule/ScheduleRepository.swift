import Foundation

import RxSwift

import Core

public protocol ScheduleRepository {
    func fetchMonthAcademicSchedule(req: ScheduleRequestParams) -> Single<AcademicScheduleEntity>
    func fetchTodayTimeTable() -> Single<TimeTableEntity>
    func fetchWeekTimeTable() -> Single<WeekTimeTableEntity>
}
