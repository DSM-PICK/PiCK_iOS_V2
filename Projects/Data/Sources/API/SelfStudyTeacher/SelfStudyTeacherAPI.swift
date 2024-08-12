import Foundation

import Moya

import Core
import Domain
import AppNetwork

public enum SelfStudyTeacherAPI {
    case fetchSelfstudyTeacherCheck(date: String)
}

extension SelfStudyTeacherAPI: PiCKAPI {
    public typealias ErrorType = PiCKError
    
    public var urlType: PiCKURL {
        return .selfStudy
    }
    
    public var urlPath: String {
        switch self {
            case .fetchSelfstudyTeacherCheck:
                return "/today"
        }
    }
    
    public var method: Moya.Method {
        switch self {
            case .fetchSelfstudyTeacherCheck:
                return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
            case .fetchSelfstudyTeacherCheck(let date):
                return .requestParameters(
                    parameters: ["date": date],
                    encoding: URLEncoding.queryString
                )
        }
    }
    
    public var pickHeader: tokenType {
        return .accessToken
    }

    public var errorMap: [Int : PiCKError]? {
        return nil
    }

}
