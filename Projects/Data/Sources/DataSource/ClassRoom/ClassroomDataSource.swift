import Foundation

import RxSwift
import Moya
import RxMoya

import AppNetwork
import Domain

protocol ClassroomDataSource {
    func classroomMoveApply(req: ClassRoomMoveRequestParams) -> Completable
    func classroomReturn() -> Completable
}

class ClassroomDataSourceImpl: BaseDataSource<ClassroomAPI>, ClassroomDataSource {
    func classroomMoveApply(req: ClassRoomMoveRequestParams) -> Completable {
        return request(.classroomMoveApply(req: req))
            .asCompletable()
    }

    func classroomReturn() -> Completable {
        return request(.classroomReturn)
            .asCompletable()
    }

}
