import Foundation

import RxSwift

public protocol AuthRepository {
    func login(req: LoginRequestParams) -> Completable
    func logout()
    func refreshToken() -> Completable
}
