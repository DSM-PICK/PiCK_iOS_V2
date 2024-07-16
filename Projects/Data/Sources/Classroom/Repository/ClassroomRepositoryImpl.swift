import Foundation

import RxSwift

import Domain

class ClassroomRepositoryImpl: ClassroomRepository {
    let remoteDataSource = ClassroomDataSource.shared
    
    func classroomMoveApply(floor: Int, classroomName: String, startPeriod: Int, endPeriod: Int) -> Completable {
        return remoteDataSource.classroomMoveApply(
            floor: floor, 
            classroomName: classroomName,
            startPeriod: startPeriod,
            endPeriod: endPeriod
        )
    }
    
    func classroomReturn() -> Completable {
        return remoteDataSource.classroomReturn()
    }
    
}
