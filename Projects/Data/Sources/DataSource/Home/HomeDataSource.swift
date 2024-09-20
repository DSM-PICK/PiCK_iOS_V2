import Foundation

import RxSwift
import RxMoya
import Moya

import Core
import AppNetwork

protocol HomeDataSource {
    func fetchHomeData() -> Single<Response>
}

class HomeDataSourceImpl: BaseDataSource<HomeAPI>, HomeDataSource {
    func fetchHomeData() -> Single<Response> {
        return request(.fetchHomeApplyStatus)
            .filterSuccessfulStatusCodes()
    }
    
}
