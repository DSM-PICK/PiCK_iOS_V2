import Foundation

import RxSwift
import Moya
import RxMoya

import Core
import AppNetwork
import Domain

protocol WeekendMealDataSource {
//    func weekendMealApply(status: WeekendMealTypeEnum.RawValue) -> Completable
    func weekendMealCheck() -> Single<Response>
}

class WeekendMealDataSourceImpl: BaseDataSource<WeekendMealAPI>, WeekendMealDataSource {
//    func weekendMealApply(status: WeekendMealTypeEnum.RawValue) -> Completable {
//        return request(.weekendMealApply(status: status))
//        .asCompletable()
//    }
    
    func weekendMealCheck() -> Single<Response> {
        return request(.weekendMealCheck)
            .filterSuccessfulStatusCodes()
    }
    
    
}
