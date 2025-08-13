import Foundation

import RxSwift

public class SignUpUseCase {
    let repository: AuthRepository

    public init(repository: AuthRepository) {
        self.repository = repository
    }

    public func execute(req: SignUpRequestParams) -> Completable {
        return repository.signUp(req: req)
    }

}
