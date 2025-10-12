import Foundation

import RxSwift

public protocol MailRepository {
    func verifyEmailCode(req: VerifyEmailCodeRequestParams) -> Completable
    func mailCodeCheck(req: MailCodeCheckRequestParams) -> Single<Bool>
}
