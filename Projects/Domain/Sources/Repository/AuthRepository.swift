import Foundation

import RxSwift

public protocol AuthRepository {
    func signin(req: SigninRequestParams) -> Completable
    func signup(req: SignupRequestParams) -> Completable
    func passwordChange(req: PasswordChangeRequestParams) -> Completable
    func logout()
    func resign() -> Completable
    func refreshToken() -> Completable
}
