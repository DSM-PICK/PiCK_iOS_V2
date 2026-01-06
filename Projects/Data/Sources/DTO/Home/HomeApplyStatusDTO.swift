import Foundation

import Core
import Domain

public struct HomeApplyStatusDTO: Decodable {
    let userID: UUID?
    let userName: String?
    let startTime: String?
    let endTime: String?
    let classroom: String?
    let type: OutingType.RawValue

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case userName = "user_name"
        case startTime = "start"
        case endTime = "end"
        case classroom
        case type
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
            type: type
        )
    }

}
