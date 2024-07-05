import Foundation

import Moya

import Core

public enum NoticeAPI {
    case fetchTodayNoticeList
    case fetchNoticeList
    case fetchDetailNotice(id: UUID)
}

extension NoticeAPI: PiCKAPI {
    public var urlType: PiCKURL {
        return .notice
    }
    
    public var urlPath: String {
        switch self {
            case .fetchTodayNoticeList:
                return "/today"
            case .fetchNoticeList:
                return "/simple"
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
    
    public var pickHeader: tokenType {
        return .accessToken
    }
    
    
}
