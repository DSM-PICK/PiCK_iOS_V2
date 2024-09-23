import Foundation

import RxSwift

import Core

public class FetchApplyStatusUsecase {
    let repository: HomeRepository

    public init(repository: HomeRepository) {
        self.repository = repository
    }

    public func execute() -> Single<HomeApplyStatusEntity> {
        return repository.fetchApplyStatus()
    }

}
