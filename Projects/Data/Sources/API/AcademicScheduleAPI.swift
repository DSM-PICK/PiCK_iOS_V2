import Foundation

import Moya

import Core
import Domain
import AppNetwork

public enum AcademicScheduleAPI {
    case fetchMonthAcademicSchedule(req: AcademicScheduleRequestParams)
    case loadAcademicSchedule(date: String)
}

extension AcademicScheduleAPI: PiCKAPI {
    public typealias ErrorType = PiCKError

    public var domain: PiCKDomain {
        return .schedule
    }

    public var urlPath: String {
        switch self {
        case .fetchMonthAcademicSchedule:
            return "/month"
        case .loadAcademicSchedule:
            return "/date"
        }
    }

    public var method: Moya.Method {
        return .get
    }

    public var task: Moya.Task {
        switch self {
        case let .fetchMonthAcademicSchedule(req):
            return .requestParameters(
                parameters: [
                    "year": req.year,
                    "month": req.month
                ],
                encoding: URLEncoding.queryString
            )
        case let .loadAcademicSchedule(date):
            return .requestParameters(
                parameters: [
                    "date": date
                ],
                encoding: URLEncoding.queryString
            )
        }
    }

    public var pickHeader: TokenType {
        return .accessToken
    }

    public var errorMap: [Int: PiCKError]? {
        return nil
    }

}
