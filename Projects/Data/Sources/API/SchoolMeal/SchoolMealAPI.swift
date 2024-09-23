import Foundation

import Moya

import Core
import Domain
import AppNetwork

public enum SchoolMealAPI {
    case fetchSchoolMeal(date: String)
}

extension SchoolMealAPI: PiCKAPI {
    public typealias ErrorType = PiCKError
    
    public var urlType: PiCKURL {
        return .meal
    }
    
    public var urlPath: String {
        switch self {
            case .fetchSchoolMeal:
                return "/date"
        }
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var task: Moya.Task {
        switch self {
            case .fetchSchoolMeal(let date):
                return .requestParameters(
                    parameters: ["date": date],
                    encoding: URLEncoding.queryString
                )
        }
    }
    
    public var pickHeader: TokenType {
        return .accessToken
    }

    public var errorMap: [Int : PiCKError]? {
        return nil
    }

}

