import Foundation

import RxSwift

public struct LogoutUseCase {
    let repository: AuthRepository

    public init(repository: AuthRepository) {
        self.repository = repository
    }

    public func execute() {
        repository.logout()
    }
}
