import Foundation

import RxSwift

public class ClassroomReturnUseCase {
    let repository: ClassroomRepository

    public init(repository: ClassroomRepository) {
        self.repository = repository
    }

    public func execute() -> Completable {
        return repository.classroomReturn()
    }

}
