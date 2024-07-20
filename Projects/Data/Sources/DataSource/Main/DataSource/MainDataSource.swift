import Foundation

import RxSwift
import RxMoya
import Moya

import Core
import AppNetwork

protocol MainDataSource {
    func fetchMainData() -> Single<Response>
}

class MainDataSourceImpl: BaseDataSource<MainAPI>, MainDataSource {
    func fetchMainData() -> Single<Response> {
        return request(.fetchMainData)
            .filterSuccessfulStatusCodes()
    }
    
}
