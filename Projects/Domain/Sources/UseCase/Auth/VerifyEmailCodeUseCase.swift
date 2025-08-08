import Foundation

import RxSwift

public struct VerifyEmailCodeUseCase {
    let repository: AuthRepository

    public init(repository: AuthRepository) {
        self.repository = repository
    }

    public func execute(req: VerifyEmailCodeRequestParams) -> Completable {
        return repository.verifyEmailCode(req: req)
    }
}
