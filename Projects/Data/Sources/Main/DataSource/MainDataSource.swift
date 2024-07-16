import Foundation

import RxSwift
import RxMoya
import Moya

import Core
import AppNetwork

class MainDataSource {
    
    private let provider = MoyaProvider<MainAPI>(plugins: [MoyaLoggingPlugin()])
    
    static let shared = MainDataSource()
    private init() {}
    
    func fetchMainData() -> Single<Response> {
        return provider.rx.request(.fetchMainData)
            .filterSuccessfulStatusCodes()
    }
    
}
