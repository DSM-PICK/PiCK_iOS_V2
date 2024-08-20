import Foundation

import Core
import Domain

public struct OutingPassDTO: Decodable {
    let userName: String
    let teacherName: String
    let startTime: String
    let endTime: String
    let reason: String
    let schoolNum: Int
    let type: OutingType.RawValue
    
    enum CodingKeys: String, CodingKey {
        case reason, type
        case userName = "username"
        case teacherName = "teacher_name"
        case startTime = "start_time"
        case endTime = "end_time"
        case schoolNum = "school_num"
    }
}

extension OutingPassDTO {
    func toDomain() -> OutingPassEntity {
        return .init(
            userName: userName,
            teacherName: teacherName,
            startTime: startTime,
            endTime: endTime,
            reason: reason,
            schoolNum: schoolNum,
            type: type
        )
    }
    
}
