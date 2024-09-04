import Foundation

import Core
import Domain

public struct HomeApplyStatusDTO: Decodable {
    let userID: UUID?
    let userName: String?
    let startTime: String?
    let endTime: String?
    let classroom: String?
    let startPeriod: Int?
    let endPeriod: Int?
    let type: OutingType.RawValue?
    
    enum CodingKeys: String, CodingKey {
        case classroom, type
        case userID = "user_id"
        case userName = "username"
        case startTime = "start"
        case endTime = "end"
        case startPeriod = "start_period"
        case endPeriod = "end_period"
    }
    
}

extension HomeApplyStatusDTO {
    func toDomain() -> HomeApplyStatusEntity {
        return .init(
            userID: userID,
            userName: userName,
            startTime: startTime,
            endTime: endTime,
            classroom: classroom,
            startPeriod: startPeriod,
            endPeriod: endPeriod,
            type: type
        )
    }
    
}
