import Foundation

import Core
import Domain

public struct OutingPassDTO: Decodable {
    let userName: String
    let teacherName: String
    let startTime: String?
    let start: String?
    let end: String?
    let reason: String
    let schoolNum: Int?
    let grade: Int?
    let classNum: Int?
    let num: Int?
    let type: OutingType.RawValue

    enum CodingKeys: String, CodingKey {
        case reason, type, grade, num
        case userName = "username"
        case teacherName = "teacher_name"
        case startTime = "start_time"
        case start = "start"
        case schoolNum = "school_num"
        case end = "end"
        case classNum = "class_num"
    }
}

extension OutingPassDTO {
    func toDomain() -> OutingPassEntity {
        return .init(
            userName: userName,
            teacherName: teacherName,
            startTime: startTime,
            start: start,
            end: end,
            reason: reason,
            schoolNum: schoolNum,
            grade: grade,
            classNum: classNum,
            num: num,
            type: type
        )
    }

}
