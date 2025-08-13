import Foundation

import RxSwift

public protocol AuthRepository {
    func signin(req: SigninRequestParams) -> Completable
    func signUp(req: SignUpRequestParams) -> Completable
    func logout()
    func refreshToken() -> Completable
}
