import Foundation

import RxSwift

import Core

public protocol TimeTableRepository {
    func fetchTodayTimeTable() -> Single<TimeTableEntity>
    func fetchWeekTimeTable() -> Single<WeekTimeTableEntity>
}
