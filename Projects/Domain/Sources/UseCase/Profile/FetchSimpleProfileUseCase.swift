import Foundation

import RxSwift

public class FetchSimpleProfileUseCase {
    let repository: ProfileRepository

    public init(repository: ProfileRepository) {
        self.repository = repository
    }

    public func execute() -> Single<SimpleProfileEntity> {
        return repository.fetchSimpleProfile()
    }

}
