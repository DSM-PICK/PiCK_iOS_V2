import Foundation

import RxSwift

import Core

public protocol WeekendMealRepository {
    func weekendMealApply(status: WeekendMealType.RawValue) -> Completable
    func weekendMealStatus() -> Single<WeekendMealStatusEntity>
}
