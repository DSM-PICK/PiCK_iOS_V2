import Foundation

import RxSwift

public class SignupUseCase {
    let repository: AuthRepository

    public init(repository: AuthRepository) {
        self.repository = repository
    }

    public func execute(req: SignupRequestParams) -> Completable {
        return repository.signup(req: req)
    }

}
