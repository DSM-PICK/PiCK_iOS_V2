import Foundation

import RxSwift

import Core

public class FetchWeekendMealApplicationUseCase {
    let repository: WeekendMealRepository

    public init(repository: WeekendMealRepository) {
        self.repository = repository
    }

    public func execute() -> Single<WeekendMealApplicationEntity> {
        return repository.weekendMealApplication()
    }
}
