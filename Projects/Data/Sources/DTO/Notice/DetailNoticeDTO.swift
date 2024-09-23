import Foundation

import Domain

public struct DetailNoticeDTO: Decodable {
    let title: String
    let content: String
    let createAt: String
    let teacher: String

    enum CodingKeys: String, CodingKey {
        case title, content, teacher
        case createAt = "create_at"
    }

}

extension DetailNoticeDTO {
    func toDomain() -> DetailNoticeEntity {
        return .init(
            title: title,
            content: content,
            createAt: createAt,
            teacher: teacher
        )
    }

}
