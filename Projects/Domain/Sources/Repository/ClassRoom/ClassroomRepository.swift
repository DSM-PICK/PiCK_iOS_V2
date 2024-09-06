import Foundation

import RxSwift

public protocol ClassroomRepository {
    func classroomMoveApply(req: ClassroomMoveRequestParams) -> Completable
    func classroomReturn() -> Completable
}
