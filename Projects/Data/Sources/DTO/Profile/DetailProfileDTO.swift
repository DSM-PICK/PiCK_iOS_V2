import Foundation

import Domain

public struct DetailProfileDTO: Decodable {
    let name: String
    let birthDay: String
    let grade: Int
    let classNum: Int
    let num: Int
    let accountID: String
    let profile: String?

    enum CodingKeys: String, CodingKey {
        case profile, grade, num
        case name = "user_name"
        case classNum = "class_num"
        case birthDay = "birth_day"
        case accountID = "account_id"
    }

}

extension DetailProfileDTO {
    func toDomain() -> DetailProfileEntity {
        return .init(
            name: name,
            birthDay: birthDay,
            grade: grade,
            classNum: classNum,
            num: num,
            accountID: accountID,
            profile: profile
        )
    }

}
