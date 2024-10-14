import Foundation

import Moya

import Core
import Domain
import AppNetwork

public enum SelfStudyAPI {
    case fetchSelfStudyTeacher(date: String)
}

extension SelfStudyAPI: PiCKAPI {
    public typealias ErrorType = PiCKError

    public var urlType: PiCKURL {
        return .selfStudy
    }

    public var urlPath: String {
        switch self {
        case .fetchSelfStudyTeacher:
            return "/today"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .fetchSelfStudyTeacher:
            return .get
        }
    }

    public var task: Moya.Task {
        switch self {
        case .fetchSelfStudyTeacher(let date):
            return .requestParameters(
                parameters: ["date": date],
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
