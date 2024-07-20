import Foundation

import Moya

import Core

public enum ScheduleAPI {
    case fetchMonthAcademicSchedule(year: String, month: MonthType.RawValue)
}

extension ScheduleAPI: PiCKAPI {
    public typealias ErrorType = PiCKError
    
    public var urlType: PiCKURL {
        return .schedule
    }
    
    public var urlPath: String {
        switch self {
            case .fetchMonthAcademicSchedule:
                return "/month"
        }
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var task: Moya.Task {
        switch self {
            case let .fetchMonthAcademicSchedule(year, month):
                return .requestParameters(
                    parameters: [
                        "year": year,
                        "month": month
                    ],
                    encoding: URLEncoding.queryString
                )
            default:
                return .requestPlain
        }
    }
    
    public var pickHeader: tokenType {
        return .accessToken
    }

    public var errorMap: [Int : PiCKError]? {
        return nil
    }

}
