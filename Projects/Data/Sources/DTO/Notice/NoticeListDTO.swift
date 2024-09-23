import Foundation

import Domain

public struct NoticeListDTOElement: Decodable {
    let id: UUID
    let title: String
    let createAt: String

    enum CodingKeys: String, CodingKey {
        case id, title
        case createAt = "create_at"
    }
}

extension NoticeListDTOElement {
    func toDomain() -> NoticeListEntityElement {
        return .init(
            id: id,
            title: title,
            createAt: createAt
        )
    }
}

public typealias NoticeListDTO = [NoticeListDTOElement]

extension NoticeListDTO {
    func toDomain() -> NoticeListEntity {
        return self.map { $0.toDomain() }
    }
}
