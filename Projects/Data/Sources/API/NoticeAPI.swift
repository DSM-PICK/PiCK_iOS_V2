import Foundation

import Moya

import Core
import Domain
import AppNetwork

public enum NoticeAPI {
    case fetchNoticeList
    case fetchSimpleNoticeList
    case fetchDetailNotice(id: UUID)
}

extension NoticeAPI: PiCKAPI {
    public typealias ErrorType = PiCKError

    public var urlType: PiCKURL {
        return .notice
    }

    public var urlPath: String {
        switch self {
        case .fetchNoticeList:
            return "/simple"
        case .fetchSimpleNoticeList:
            return "/today"
        case .fetchDetailNotice(let id):
            return "/\(id)"
        }
    }

    public var method: Moya.Method {
        return .get
    }

    public var task: Moya.Task {
        return .requestPlain
    }

    public var pickHeader: TokenType {
        return .accessToken
    }

    public var errorMap: [Int: PiCKError]? {
        return nil
    }

}
