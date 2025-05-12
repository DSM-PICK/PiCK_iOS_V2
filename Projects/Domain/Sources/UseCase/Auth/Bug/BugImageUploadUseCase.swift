import Foundation

import RxSwift

import Moya

public class BugImageUploadUseCase {
    let repository: BugRepository

    public init(repository: BugRepository) {
        self.repository = repository
    }

    public func execute(images: [Data]) -> Single<[String]> {
        return repository.uploadImage(images: images)
    }

}
