import Foundation

import RxSwift

import Domain

class ClassroomRepositoryImpl: ClassroomRepository {
    let remoteDataSource: ClassroomDataSourceImpl

    init(remoteDataSource: ClassroomDataSourceImpl) {
        self.remoteDataSource = remoteDataSource
    }

    func classroomMoveApply(req: ClassRoomMoveRequestParams) -> Completable {
        return remoteDataSource.classroomMoveApply(req: req)
    }
    
    func classroomReturn() -> Completable {
        return remoteDataSource.classroomReturn()
    }

}
