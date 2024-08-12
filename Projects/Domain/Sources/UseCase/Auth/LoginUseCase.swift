import Foundation

import RxSwift

public class LoginUseCase {

    let repository: any AuthRepository
    
    public init(repository: any AuthRepository) {
        self.repository = repository
    }

    public func execute(req: LoginRequestParams) -> Completable {
        return repository.login(req: req)
    }

}
