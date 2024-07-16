import Foundation

import RxSwift

import Core

public protocol SchoolMealRepository {
    func fetchSchoolMeal(date: String) -> Single<SchoolMealEntity>
}
