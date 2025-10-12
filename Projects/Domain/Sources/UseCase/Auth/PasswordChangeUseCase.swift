import Foundation

import RxSwift

public class PasswordChangeUseCase {
    let repository: AuthRepository

    public init(repository: AuthRepository) {
        self.repository = repository
    }

    public func execute(req: PasswordChangeRequestParams) -> Completable {
        return repository.passwordChange(req: req)
    }

}
