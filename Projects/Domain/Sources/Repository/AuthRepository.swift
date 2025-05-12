import Foundation

import RxSwift

public protocol AuthRepository {
    func signin(req: SigninRequestParams) -> Completable
    func logout()
    func refreshToken() -> Completable
//    func signup
}
