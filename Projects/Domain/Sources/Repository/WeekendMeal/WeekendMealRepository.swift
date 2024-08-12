import Foundation

import RxSwift

import Core

public protocol WeekendMealRepository {
    func weekendMealApply(status: String) -> Completable
    func weekendMealCheck() -> Single<WeekendMealCheckEntity>
}
