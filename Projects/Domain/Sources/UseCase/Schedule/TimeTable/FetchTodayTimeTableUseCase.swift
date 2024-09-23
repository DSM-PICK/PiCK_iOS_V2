import Foundation

import RxSwift

import Core

public class FetchTodayTimeTableUseCase {
    let repository: TimeTableRepository

    public init(repository: TimeTableRepository) {
        self.repository = repository
    }

    public func execute() -> Single<TimeTableEntity> {
        return repository.fetchTodayTimeTable()
    }

}
