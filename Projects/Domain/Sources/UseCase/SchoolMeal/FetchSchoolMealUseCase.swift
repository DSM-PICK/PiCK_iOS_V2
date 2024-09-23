import Foundation

import RxSwift

import Core

public class FetchSchoolMealUseCase {
    let repository: SchoolMealRepository

    public init(repository: SchoolMealRepository) {
        self.repository = repository
    }

    public func execute(date: String) -> Single<SchoolMealEntity> {
        return repository.fetchSchoolMeal(date: date)
    }

}
