import Foundation

import Core
import Domain

public struct OutingPassDTO: Decodable {
    let userName: String
    let teacherName: String
    let start: String?
    let end: String?
    let reason: String?
    let grade: Int?
    let classNum: Int?
    let num: Int?
    let type: OutingType.RawValue

    enum CodingKeys: String, CodingKey {
        case start, end, reason, type, grade, num
        case userName = "user_name"
        case teacherName = "teacher_name"
        case classNum = "class_num"
    }
}

extension OutingPassDTO {
    func toDomain() -> OutingPassEntity {
        return .init(
            userName: userName,
            teacherName: "\(teacherName) 선생님",
            time: "\(start ?? "") ~ \(end ?? "")",
            reason: reason ?? "",
            gcn: "\(grade ?? 0)학년 \(classNum ?? 0)반 \(num ?? 0)번",
            type: type
        )
    }

}
