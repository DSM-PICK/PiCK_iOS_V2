import Foundation

import Domain

public struct SimpleProfileDTO: Decodable {
    let name: String
    let grade: Int
    let classNum: Int
    let num: Int
    let profile: String?

    enum CodingKeys: String, CodingKey {
        case name, grade, num, profile
        case classNum = "class_num"
    }
}

extension SimpleProfileDTO {
    func toDomain() -> SimpleProfileEntity {
        return .init(
            name: name,
            grade: grade,
            classNum: classNum,
            num: num,
            profile: profile
        )
    }
}
