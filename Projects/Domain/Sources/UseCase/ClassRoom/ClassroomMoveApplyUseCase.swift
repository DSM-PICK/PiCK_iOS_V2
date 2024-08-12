import Foundation

import RxSwift

public class ClassroomMoveApplyUseCase {

    let repository: ClassroomRepository
    
    public init(repository: ClassroomRepository) {
        self.repository = repository
    }

    public func execute(req: ClassRoomMoveRequestParams) -> Completable {
        return repository.classroomMoveApply(req: req)
    }
    
}
