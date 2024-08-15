import Foundation

import Moya
import RxSwift

import AppNetwork
import Core
import Domain

class AuthRepositoryImpl: AuthRepository {

    private let remoteDataSource: AuthDataSource
    private var disposeBag = DisposeBag()
    private let keyChain = KeychainImpl()
    
    init(remoteDataSource: AuthDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func login(req: LoginRequestParams) -> Completable {
        return Completable.create { [weak self] completable in
            guard let self = self else { return Disposables.create {} }

            self.remoteDataSource.login(req: req)
                .subscribe(onSuccess: { tokenData in
                    self.keyChain.save(type: .accessToken, value: tokenData.accessToken)
                    self.keyChain.save(type: .refreshToken, value: tokenData.refreshToken)
                    completable(.completed)
                }, onFailure: {
                    completable(.error($0))
                })
                .disposed(by: self.disposeBag)

            return Disposables.create {}
        }
    }

    func logout() {
        return remoteDataSource.logout()
    }

    func refreshToken() -> Completable {
        return Completable.create { [weak self] completable in
            guard let self = self else { return Disposables.create {} }

            self.remoteDataSource.refreshToken()
                .subscribe(onSuccess: { tokenData in
                    self.keyChain.save(type: .accessToken, value: tokenData.accessToken)
                    self.keyChain.save(type: .refreshToken, value: tokenData.refreshToken)
                    completable(.completed)
                }, onFailure: {
                    completable(.error($0))
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create {}
        }
    }

}
