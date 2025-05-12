import Foundation

import RxSwift

public class SigninUseCase {
    let repository: AuthRepository

    public init(repository: AuthRepository) {
        self.repository = repository
    }

    public func execute(req: SigninRequestParams) -> Completable {
        return repository.signin(req: req)
    }

}
