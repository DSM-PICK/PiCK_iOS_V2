import Foundation

import RxSwift

public struct ResignUseCase {
    let repository: AuthRepository

    public init(repository: AuthRepository) {
        self.repository = repository
    }

    public func execute() {
        repository.resign()
    }
}
