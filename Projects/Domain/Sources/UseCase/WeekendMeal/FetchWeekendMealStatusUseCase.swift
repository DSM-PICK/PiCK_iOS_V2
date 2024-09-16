import Foundation

import RxSwift

import Core

public class FetchWeekendMealStatusUseCase {
    let repository: WeekendMealRepository

    public init(repository: WeekendMealRepository) {
        self.repository = repository
    }

    public func execute() -> Single<WeekendMealStatusEntity> {
        return repository.weekendMealStatus()
    }
}
