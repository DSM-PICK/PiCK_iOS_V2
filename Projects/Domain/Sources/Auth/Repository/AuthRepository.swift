import Foundation

import RxSwift

public protocol AuthRepository {
    func login(accountID: String, password: String) -> Completable
    func refreshToken() -> Completable
}
