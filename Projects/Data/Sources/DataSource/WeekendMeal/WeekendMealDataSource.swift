import Foundation

import RxSwift
import Moya
import RxMoya

import Core
import Domain
import AppNetwork

protocol WeekendMealDataSource {
    func weekendMealApply(status: WeekendMealType.RawValue) -> Completable
    func weekendMealStatus() -> Single<Response>
}

class WeekendMealDataSourceImpl: BaseDataSource<WeekendMealAPI>, WeekendMealDataSource {
    func weekendMealApply(status: WeekendMealType.RawValue) -> Completable {
        return request(.weekendMealApply(status: status))
            .filterSuccessfulStatusCodes()
            .asCompletable()
    }

    func weekendMealStatus() -> Single<Response> {
        return request(.weekendMealCheck)
            .filterSuccessfulStatusCodes()
    }

}
