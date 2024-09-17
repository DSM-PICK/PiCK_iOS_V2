import Foundation

import RxSwift

import Core

public class FetchWeekendMealPeriodUseCase {
    let repository: WeekendMealRepository

    public init(repository: WeekendMealRepository) {
        self.repository = repository
    }

    public func execute() -> Single<WeekendMealPeriodEntity> {
        return repository.weekendMealPeriod()
    }
}
