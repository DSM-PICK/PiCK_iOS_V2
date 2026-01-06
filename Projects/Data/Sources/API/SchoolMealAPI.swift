import Foundation

import Moya

import Core
import Domain
import AppNetwork

public enum SchoolMealAPI {
    case fetchSchoolMeal(date: String)
}

extension SchoolMealAPI: TargetType {
    public var baseURL: URL {
        return URLUtil.neisBaseURL
    }

    public var path: String {
        switch self {
        case .fetchSchoolMeal:
            return "/mealServiceDietInfo"
        }
    }

    public var method: Moya.Method {
        return .get
    }

    public var task: Moya.Task {
        switch self {
        case .fetchSchoolMeal(let date):
            let neisDate = date.replacingOccurrences(of: "-", with: "")
            return .requestParameters(
                parameters: [
                    "KEY": URLUtil.neisAPIKey,
                    "Type": "json",
                    "pIndex": 1,
                    "pSize": 100,
                    "ATPT_OFCDC_SC_CODE": URLUtil.neisAtptOfcdcScCode,
                    "SD_SCHUL_CODE": URLUtil.neisSdSchulCode,
                    "MLSV_YMD": neisDate
                ],
                encoding: URLEncoding.queryString
            )
        }
    }

    public var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }

    public var validationType: ValidationType {
        return .successCodes
    }
}
