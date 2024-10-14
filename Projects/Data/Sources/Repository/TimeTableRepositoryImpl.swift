import Foundation

import RxSwift

import Core
import Domain

class TimeTableRepositoryImpl: TimeTableRepository {
    let remoteDataSource: TimeTableDataSource

    init(remoteDataSource: TimeTableDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func fetchTodayTimeTable() -> Single<TimeTableEntity> {
        return remoteDataSource.fetchTodayTimeTable()
            .map(TimeTableDTO.self)
            .map { $0.toDomain() }
    }

    func fetchWeekTimeTable() -> Single<WeekTimeTableEntity> {
        return remoteDataSource.fetchWeekTimeTable()
            .map(WeekTimeTableDTO.self)
            .map { $0.toDomain() }
    }

}
