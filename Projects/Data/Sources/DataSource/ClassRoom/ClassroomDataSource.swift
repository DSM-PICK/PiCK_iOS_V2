import Foundation

import RxSwift
import Moya
import RxMoya

import AppNetwork
import Domain

protocol ClassroomDataSource {
    func classroomMoveApply(req: ClassroomMoveRequestParams) -> Completable
    func classroomReturn() -> Completable
}

class ClassroomDataSourceImpl: BaseDataSource<ClassroomAPI>, ClassroomDataSource {
    func classroomMoveApply(req: ClassroomMoveRequestParams) -> Completable {
        return request(.classroomMoveApply(req: req))
            .asCompletable()
    }

    func classroomReturn() -> Completable {
        return request(.classroomReturn)
            .asCompletable()
    }

}
