import Foundation

import RxSwift
import RxMoya
import Moya

import Core
import AppNetwork

protocol HomeDataSource {
    func fetchMainData() -> Single<Response>
}

class HomeDataSourceImpl: BaseDataSource<HomeAPI>, HomeDataSource {
    func fetchMainData() -> Single<Response> {
        return request(.fetchHomeApplyStatus)
            .filterSuccessfulStatusCodes()
    }
    
}
