import Foundation

import RxSwift

import Core

public protocol WeekendMealRepository {
//    func weekendMealApply(status: WeekendMealTypeEnum.RawValue) -> Completable
    func weekendMealCheck() -> Single<WeekendMealCheckEntity>
}
