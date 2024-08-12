import Foundation

import RxSwift

public protocol AuthRepository {
    func login(req: LoginRequestParams) -> Completable
    func refreshToken() -> Completable
}
