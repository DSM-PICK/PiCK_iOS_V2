import Foundation

import Domain

public struct DetailProfileDTO: Decodable {
    let name: String
    let grade: Int
    let classNum: Int
    let num: Int
    let accountID: String
    let profile: String?

    enum CodingKeys: String, CodingKey {
        case profile, grade, num
        case name = "user_name"
        case classNum = "class_num"
        case accountID = "account_id"
    }

}

extension DetailProfileDTO {
    func toDomain() -> DetailProfileEntity {
        return .init(
            name: name,
            grade: grade,
            classNum: classNum,
            num: num,
            accountID: accountID,
            profile: profile
        )
    }

}
