import Foundation

public struct TimeTableDTO: Decodable, Hashable {
    public let date: String
    public var timetables: [TimeTableDTOElement?]
}

public struct TimeTableDTOElement: Decodable, Hashable {
    public let id: UUID
    public let period: Int
    public let subjectName: String
    public let image: String

    enum CodingKeys: String, CodingKey {
        case id, period, image
        case subjectName = "subject_name"
    }
}
