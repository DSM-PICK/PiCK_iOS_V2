import Foundation

import RxSwift

public class ClassroomMoveApplyUseCase {

    let repository: ClassroomRepository
    
    public init(repository: ClassroomRepository) {
        self.repository = repository
    }

    public func execute(floor: Int, classroomName: String, startPeriod: Int, endPeriod: Int) -> Completable {
        return repository.classroomMoveApply(
            floor: floor,
            classroomName: classroomName,
            startPeriod: startPeriod,
            endPeriod: endPeriod
        )
    }
    
}
