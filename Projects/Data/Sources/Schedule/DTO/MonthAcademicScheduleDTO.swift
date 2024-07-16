import Foundation

import Domain

public struct MonthAcademicScheduleDTOElement: Decodable {
    let id: UUID
    let eventName: String
    let month: Int
    let day: Int
    let dayName: String
    
    enum CodingKeys: String, CodingKey {
        case id, month, day
        case eventName = "event_name"
        case dayName = "day_name"
    }
}

extension MonthAcademicScheduleDTOElement {
    func toDomain() -> AcademicScheduleEntityElement {
        return .init(
            id: id,
            eventName: eventName,
            month: month,
            day: day,
            dayName: dayName
        )
    }
    
}


public typealias MonthAcademicScheduleDTO = [MonthAcademicScheduleDTOElement]

extension MonthAcademicScheduleDTO {
    func toDomain() -> AcademicScheduleEntity {
        return self.map { $0.toDomain() }
    }
}
