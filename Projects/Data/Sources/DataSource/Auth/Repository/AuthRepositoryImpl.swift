import Foundation

import Moya
import RxSwift

import AppNetwork
import Core
import Domain

class AuthRepositoryImpl: AuthRepository {

    private let remoteDataSource: AuthDataSource
    private var disposeBag = DisposeBag()
    
    init(remoteDataSource: AuthDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func login(accountID: String, password: String) -> Completable {
        return Completable.create { [weak self] completable in
            guard let self = self else { return Disposables.create {} }

            self.remoteDataSource.login(accountID: accountID, password: password)
                .subscribe(onSuccess: { tokenData in
//                    KeychainStorage.shared.id = accountID
//                    KeychainStorage.shared.password = password
                    TokenStorage.shared.accessToken = tokenData.accessToken
                    TokenStorage.shared.refreshToken = tokenData.refreshToken
                    completable(.completed)
                }, onFailure: {
                    completable(.error($0))
                })
                .disposed(by: self.disposeBag)

            return Disposables.create {}
        }
    }
    
    func refreshToken() -> Completable {
        return Completable.create { [weak self] completable in
            guard let self = self else { return Disposables.create {} }
            
            self.remoteDataSource.refreshToken()
                .subscribe(onSuccess: { tokenData in
                    TokenStorage.shared.accessToken = tokenData.accessToken
                    TokenStorage.shared.refreshToken = tokenData.refreshToken
                    completable(.completed)
                }, onFailure: {
                    completable(.error($0))
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create {}
        }
    }
    

}
