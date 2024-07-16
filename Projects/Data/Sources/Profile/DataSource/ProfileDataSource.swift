import Foundation

import RxSwift
import Moya
import RxMoya

import AppNetwork
import Domain

class ProfileDataSource {
    private let provider = MoyaProvider<ProfileAPI>(plugins: [MoyaLoggingPlugin()])

    static let shared = ProfileDataSource()

    func fetchSimpleProfile() -> Single<Response> {
        return provider.rx.request(.fetchSimpleProfile)
            .filterSuccessfulStatusCodes()
    }
    
    func fetchDetailProfile() -> Single<Response> {
        return provider.rx.request(.fetchDetailProfile)
            .filterSuccessfulStatusCodes()
    }
    
}
