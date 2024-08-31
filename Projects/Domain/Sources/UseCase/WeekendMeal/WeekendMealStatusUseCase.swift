import Foundation

import RxSwift

import Core

public class WeekendMealStatusUseCase {
    let repository: WeekendMealRepository

    public init(repository: WeekendMealRepository) {
        self.repository = repository
    }

    public func execute() -> Single<WeekendMealStatusEntity> {
        return repository.weekendMealStatus()
    }
}
