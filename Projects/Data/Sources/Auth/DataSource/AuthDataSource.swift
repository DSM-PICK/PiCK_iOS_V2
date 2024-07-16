import Foundation

import RxSwift
import RxMoya
import Moya

import Core
import AppNetwork

class AuthDataSource {
    
    private let provider = MoyaProvider<AuthAPI>(plugins: [MoyaLoggingPlugin()])
    
    static let shared = AuthDataSource()
    private init() {}
    
    func login(accountID: String, password: String) -> Single<TokenDTO> {
        return provider.rx.request(.login(accountID: accountID, password: password))
            .filterSuccessfulStatusCodes()
            .map(TokenDTO.self)
    }
    
    func refreshToken() -> Single<TokenDTO> {
        return provider.rx.request(.refreshToken(
            refreshToken: TokenStorage.shared.refreshToken ?? ""
        ))
        .filterSuccessfulStatusCodes()
        .map(TokenDTO.self)
    }
}
