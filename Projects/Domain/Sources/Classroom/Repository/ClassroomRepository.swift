import Foundation

import RxSwift

public protocol ClassroomRepository {
    func classroomMoveApply(floor: Int, classroomName: String, startPeriod: Int, endPeriod: Int) -> Completable
    func classroomReturn() -> Completable
}
