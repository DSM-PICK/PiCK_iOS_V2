import Foundation

import RxSwift

import Domain

class ClassroomRepositoryImpl: ClassroomRepository {
    let remoteDataSource: ClassroomDataSource

    init(remoteDataSource: ClassroomDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func classroomMoveApply(req: ClassroomMoveRequestParams) -> Completable {
        return remoteDataSource.classroomMoveApply(req: req)
    }
    
    func classroomReturn() -> Completable {
        return remoteDataSource.classroomReturn()
    }

}
