import Foundation

import Moya

import Core

public enum TimeTableAPI{
    case fetchTodayTimeTable
    case fetchWeekTimeTable
}

extension TimeTableAPI: PiCKAPI {
    public var urlType: PiCKURL {
        return .timeTable
    }
    
    public var urlPath: String {
        switch self {
            case .fetchTodayTimeTable:
                return "/today"
            case .fetchWeekTimeTable:
                return "/week"
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
