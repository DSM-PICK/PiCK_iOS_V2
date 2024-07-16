import Foundation

import Domain

public struct TimeTableDTO: Decodable {
    public let date: String
    public let timetables: [TimeTableDTOElement]
    
}

extension TimeTableDTO {
    func toDomain() -> TimeTableEntity {
        return .init(
            date: date,
            timetables: timetables.map { $0.toDomain() }
        )
    }
}

public struct TimeTableDTOElement: Decodable {
    public let id: UUID
    public let period: Int
    public let subjectName: String
    
    enum CodingKeys: String, CodingKey {
        case id, period
        case subjectName = "subject_name"
    }
    
}

extension TimeTableDTOElement {
    func toDomain() -> TimeTableEntityElement {
        return .init(
            id: id,
            period: period,
            subjectName: subjectName
        )
    }
    
}

public typealias WeekTimeTableDTO = [TimeTableDTO]

extension WeekTimeTableDTO {
    func toDomain() -> WeekTimeTableEntity {
        return self.map { $0.toDomain() }
    }
}
