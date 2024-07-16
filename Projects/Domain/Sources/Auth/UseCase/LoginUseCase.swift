import Foundation

import RxSwift

public class LoginUseCase {

    let repository: AuthRepository
    
    public init(repository: AuthRepository) {
        self.repository = repository
    }

    public func execute(accountID: String, password: String) -> Completable {
        return repository.login(accountID: accountID, password: password)
    }
    
}
