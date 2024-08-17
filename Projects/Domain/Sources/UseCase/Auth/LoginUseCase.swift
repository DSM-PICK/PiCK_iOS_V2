import Foundation

import RxSwift

public class LoginUseCase {

    let repository: AuthRepository
    
    public init(repository: AuthRepository) {
        self.repository = repository
    }

    public func execute(req: LoginRequestParams) -> Completable {
        return repository.login(req: req)
    }

}
