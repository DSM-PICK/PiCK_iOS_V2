import Foundation

import RxSwift

public protocol ClassroomRepository {
    func classroomMoveApply(req: ClassRoomMoveRequestParams) -> Completable
    func classroomReturn() -> Completable
}
