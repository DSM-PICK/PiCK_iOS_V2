import Foundation

import RxSwift

public protocol AuthRepository {
    func login(request: LoginRequestParams) -> Completable
    func refreshToken() -> Completable
}
