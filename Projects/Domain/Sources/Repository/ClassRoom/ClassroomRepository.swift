import Foundation

import RxSwift

public protocol ClassroomRepository {
    func classroomMoveApply(request: ClassRoomMoveRequestParams) -> Completable
    func classroomReturn() -> Completable
}
