import Foundation

import RxSwift

public class MailCodeCheckUseCase {
    let repository: MailRepository

    public init(repository: MailRepository) {
        self.repository = repository
    }

    public func execute(req: MailCodeCheckRequestParams) -> Completable {
        return repository.mailCodeCheck(req: req)
    }
}
