import Foundation

import RxSwift

import Core

public class WeekendMealApplyUseCase {
    let repository: WeekendMealRepository

    public init(repository: WeekendMealRepository) {
        self.repository = repository
    }

    public func execute(status: WeekendMealType) -> Completable {
        return repository.weekendMealApply(status: status.rawValue)
    }
}
