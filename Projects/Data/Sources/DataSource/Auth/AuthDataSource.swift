import Foundation

import RxSwift
import RxMoya
import Moya

import Core
import Domain
import AppNetwork

protocol AuthDataSource {
    func login(req: LoginRequestParams) -> Single<TokenDTO>
    func refreshToken() -> Single<TokenDTO>
}

class AuthDataSourceImpl: BaseDataSource<AuthAPI>, AuthDataSource {
    func login(req: LoginRequestParams) -> Single<TokenDTO> {
        return request(.login(req: req))
            .filterSuccessfulStatusCodes()
            .map(TokenDTO.self)
    }

    func refreshToken() -> Single<TokenDTO> {
        return request(.refreshToken)
            .filterSuccessfulStatusCodes()
            .map(TokenDTO.self)
    }

}
