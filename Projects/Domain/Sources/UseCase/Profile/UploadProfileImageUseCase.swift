import Foundation

import RxSwift

public class UploadProfileImageUseCase {
    let repository: ProfileRepository

    public init(repository: ProfileRepository) {
        self.repository = repository
    }

    public func execute(image: Data) -> Completable {
        return repository.uploadProfileImage(image: image)
    }

}
