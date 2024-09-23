import Foundation

import Moya

import Core
import Domain
import AppNetwork

public enum ClassroomAPI {
    case classroomMoveApply(req: ClassroomMoveRequestParams)
    case classroomReturn
}

extension ClassroomAPI: PiCKAPI {
    public typealias ErrorType = PiCKError

    public var urlType: PiCKURL {
        return .classroom
    }

    public var urlPath: String {
        switch self {
        case .classroomMoveApply:
            return "/move"
        case .classroomReturn:
            return "/return"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .classroomMoveApply:
            return .post
        case .classroomReturn:
            return .delete
        }
    }

    public var task: Moya.Task {
        switch self {
        case let .classroomMoveApply(req):
            return .requestParameters(
                parameters: [
                    "floor": req.floor,
                    "classroom_name": req.classroomName,
                    "start_period": req.startPeriod,
                    "end_period": req.endPeriod
                ],
                encoding: JSONEncoding.default
            )
        default:
            return .requestPlain
        }
    }

    public var pickHeader: TokenType {
        switch self {
        default:
            return .accessToken
        }
    }

    public var errorMap: [Int: PiCKError]? {
        return nil
    }

}
