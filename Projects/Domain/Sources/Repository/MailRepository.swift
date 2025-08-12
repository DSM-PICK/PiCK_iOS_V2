import Foundation

import RxSwift

public protocol MailRepository {
    func verifyEmailCode(req: VerifyEmailCodeRequestParams) -> Completable
}
