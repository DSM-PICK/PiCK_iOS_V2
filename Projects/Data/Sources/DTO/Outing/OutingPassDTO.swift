import Foundation

import Core
import Domain

public struct OutingPassDTO: Decodable {
    let userName: String
    let teacherName: String
    let start: String?
    let end: String?
    let reason: String
    let schoolNum: Int?
    let grade: Int?
    let classNum: Int?
    let num: Int?
    let type: OutingType.RawValue

    enum CodingKeys: String, CodingKey {
        case start, end, reason, type, grade, num
        case userName = "user_name"
        case teacherName = "teacher_name"
        case schoolNum = "school_num"
        case classNum = "class_num"
    }
}

extension OutingPassDTO {
    func toDomain() -> OutingPassEntity {
        return .init(
            userName: userName,
            teacherName: teacherName,
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
