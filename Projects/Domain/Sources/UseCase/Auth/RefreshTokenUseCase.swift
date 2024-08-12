import Foundation

import RxSwift

public class RefreshTokenUseCase {

    let repository: any AuthRepository
    
    public init(repository: any AuthRepository) {
        self.repository = repository
    }

    public func execute() -> Completable {
        return repository.refreshToken()
    }
    
}
