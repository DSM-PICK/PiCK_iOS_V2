import Foundation

import RxSwift
import RxMoya
import Moya

import Core
import Domain
import AppNetwork

protocol AuthDataSource {
    func signin(req: SigninRequestParams) -> Single<TokenDTO>
    func signup(req: SignupRequestParams) -> Completable
    func passwordChange(req: PasswordChangeRequestParams) -> Completable
    func logout()
    func resign() -> Completable
    func refreshToken() -> Single<TokenDTO>
}

class AuthDataSourceImpl: BaseDataSource<AuthAPI>, AuthDataSource {

    private let keychain: any Keychain

    public override init(keychain: any Keychain) {
        self.keychain = keychain
        super.init(keychain: keychain)
    }

    func signin(req: SigninRequestParams) -> Single<TokenDTO> {
        return request(.signin(req: req))
            .filterSuccessfulStatusCodes()
            .map(TokenDTO.self)
    }

    func signup(req: SignupRequestParams) -> Completable {
        return request(.signup(req: req))
            .filterSuccessfulStatusCodes()
            .asCompletable()
    }

    func passwordChange(req: PasswordChangeRequestParams) -> Completable {
        return request(.passwordChange(req: req))
            .filterSuccessfulStatusCodes()
            .asCompletable()
    }

    func logout() {
        keychain.delete(type: .accessToken)
        keychain.delete(type: .refreshToken)
        keychain.delete(type: .id)
        keychain.delete(type: .password)
        UserDefaultStorage.shared.remove(forKey: .userInfoData)
    }

    func resign() -> Completable {
        return request(.resign)
            .filterSuccessfulStatusCodes()
            .asCompletable()
            .do(onCompleted: { [weak self] in
                guard let self else { return }
                self.keychain.delete(type: .accessToken)
                self.keychain.delete(type: .refreshToken)
                self.keychain.delete(type: .id)
                self.keychain.delete(type: .password)
                UserDefaultStorage.shared.remove(forKey: .userInfoData)
            })
    }

    func refreshToken() -> Single<TokenDTO> {
        return request(.refreshToken)
            .filterSuccessfulStatusCodes()
            .map(TokenDTO.self)
    }

}
