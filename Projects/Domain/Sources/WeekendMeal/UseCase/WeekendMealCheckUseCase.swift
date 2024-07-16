import Foundation

import RxSwift

import Core

public class WeekendMealCheckUseCase {
    let repository: WeekendMealRepository

    public init(repository: WeekendMealRepository) {
        self.repository = repository
    }

    public func execute() -> Single<WeekendMealCheckEntity> {
        return repository.weekendMealCheck()
    }
}
