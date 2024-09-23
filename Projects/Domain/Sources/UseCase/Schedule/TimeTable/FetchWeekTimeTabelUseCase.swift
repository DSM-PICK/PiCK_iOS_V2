import Foundation

import RxSwift

import Core

public class FetchWeekTimeTableUseCase {
    let repository: TimeTableRepository

    public init(repository: TimeTableRepository) {
        self.repository = repository
    }

    public func execute() -> Single<WeekTimeTableEntity> {
        return repository.fetchWeekTimeTable()
    }

}
