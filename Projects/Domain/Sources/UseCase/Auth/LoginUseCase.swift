import Foundation

import RxSwift

public class LoginUseCase {

    let repository: any AuthRepository
    
    public init(repository: any AuthRepository) {
        self.repository = repository
    }

    public func execute(accountID: String, password: String) -> Completable {
        return repository.login(accountID: accountID, password: password)
    }
    
}
