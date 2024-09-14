import Foundation

import RxSwift
import RxMoya
import Moya

import Core
import Domain
import AppNetwork

protocol AuthDataSource {
    func login(req: LoginRequestParams) -> Single<TokenDTO>
    func logout()
    func refreshToken() -> Single<TokenDTO>
}

class AuthDataSourceImpl: BaseDataSource<AuthAPI>, AuthDataSource {

    private let keychain: any Keychain

    public override init(keychain: any Keychain) {
        self.keychain = keychain
        super.init(keychain: keychain)
    }

    func login(req: LoginRequestParams) -> Single<TokenDTO> {
        return request(.login(req: req))
            .filterSuccessfulStatusCodes()
            .map(TokenDTO.self)
    }

    func logout() {
        keychain.delete(type: .accessToken)
        keychain.delete(type: .refreshToken)
        keychain.delete(type: .id)
        keychain.delete(type: .password)
        UserDefaultStorage.shared.remove(forKey: .userInfoData)
    }

    func refreshToken() -> Single<TokenDTO> {
        return request(.refreshToken)
            .filterSuccessfulStatusCodes()
            .map(TokenDTO.self)
    }

}
