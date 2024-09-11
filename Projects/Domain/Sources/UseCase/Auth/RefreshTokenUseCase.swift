import Foundation

import RxSwift

public class RefreshTokenUseCase {
    let repository: AuthRepository

    public init(repository: AuthRepository) {
        self.repository = repository
    }

    public func execute() -> Completable {
        return repository.refreshToken()
    }

}
