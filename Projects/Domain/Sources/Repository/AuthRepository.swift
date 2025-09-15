import Foundation

import RxSwift

public protocol AuthRepository {
    func signin(req: SigninRequestParams) -> Completable
    func signup(req: SignupRequestParams) -> Completable
    func logout()
    func refreshToken() -> Completable
}
