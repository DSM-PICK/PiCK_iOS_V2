import Foundation

import RxSwift
import RxMoya
import Moya

import Core
import AppNetwork

protocol AuthDataSource {
    func login(accountID: String, password: String) -> Single<TokenDTO>
    func refreshToken() -> Single<TokenDTO>
}

class AuthDataSourceImpl: BaseDataSource<AuthAPI>, AuthDataSource {
    func login(accountID: String, password: String) -> Single<TokenDTO> {
        return request(.login(accountID: accountID, password: password))
            .filterSuccessfulStatusCodes()
            .map(TokenDTO.self)
    }

    func refreshToken() -> Single<TokenDTO> {
        return request(.refreshToken)
            .filterSuccessfulStatusCodes()
            .map(TokenDTO.self)
    }

}
