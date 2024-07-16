import Foundation

import RxSwift
import Moya
import RxMoya

import Core
import AppNetwork
import Domain

class WeekendMealDataSource {
    private let provider = MoyaProvider<WeekendMealAPI>(plugins: [MoyaLoggingPlugin()])
    
    static let shared = WeekendMealDataSource()
    
//    func weekendMealApply(status: WeekendMealTypeEnum.RawValue) -> Completable {
//        return provider.rx.request(.weekendMealApply(status: status))
//        .asCompletable()
//    }
    
    func weekendMealCheck() -> Single<Response> {
        return provider.rx.request(.weekendMealCheck)
            .filterSuccessfulStatusCodes()
    }
    
    
}
