import Foundation

import RxSwift

public class VerifyEmailCodeUseCase {
    let repository: MailRepository

    public init(repository: MailRepository) {
        self.repository = repository
    }

    public func execute(req: VerifyEmailCodeRequestParams) -> Completable {
        return repository.verifyEmailCode(req: req)
    }
}
