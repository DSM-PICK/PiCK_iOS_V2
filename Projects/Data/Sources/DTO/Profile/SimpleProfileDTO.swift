import Foundation

import Domain

public struct SimpleProfileDTO: Decodable {
    let name: String
    let grade: Int
    let classNum: Int
    let num: Int
    let profile: String?

    enum CodingKeys: String, CodingKey {
        case grade, num, profile
        case name = "user_name"
        case classNum = "class_num"
    }
}

extension SimpleProfileDTO {
    func toDomain() -> SimpleProfileEntity {
        return .init(
            name: name,
            gcn: "\(grade)학년 \(classNum)반 \(num)번",
            profile: profile
        )
    }
}
