import Foundation

import RxSwift
import Moya
import RxMoya

import AppNetwork
import Domain

protocol ClassroomDataSource {
    func classroomMoveApply(floor: Int, classroomName: String, startPeriod: Int, endPeriod: Int) -> Completable
    func classroomReturn() -> Completable
}

class ClassroomDataSourceImpl: BaseDataSource<ClassroomAPI>, ClassroomDataSource {
    func classroomMoveApply(floor: Int, classroomName: String, startPeriod: Int, endPeriod: Int) -> Completable {
        return request(.classroomMoveApply(
            floor: floor,
            classroom: classroomName,
            startPeriod: startPeriod,
            endPeriod: endPeriod
        ))
        .asCompletable()
    }

    func classroomReturn() -> Completable {
        return request(.classroomReturn)
            .asCompletable()
    }

}
