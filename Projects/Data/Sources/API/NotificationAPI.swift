import Foundation

import Moya

import Core
import Domain
import AppNetwork

public enum NotificationAPI {
    case subscribeNotification(req: NotificationRequestParams)
    case fetchSubscribeStatus
}

extension NotificationAPI: PiCKAPI {
    public typealias ErrorType = PiCKError

    public var domain: PiCKDomain {
        return .notification
    }

    public var urlPath: String {
        switch self {
        case .subscribeNotification:
            return "/update-subscribe"
        case .fetchSubscribeStatus:
            return "/my-subscribe"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .subscribeNotification:
            return .patch
        case .fetchSubscribeStatus:
            return .get
        }
    }

    public var task: Moya.Task {
        switch self {
        case let .subscribeNotification(req):
            return .requestJSONEncodable(req)
        case .fetchSubscribeStatus:
            return .requestPlain
        }
    }

    public var pickHeader: TokenType {
        return .accessToken
    }

    public var errorMap: [Int: PiCKError]? {
        return nil
    }

}
