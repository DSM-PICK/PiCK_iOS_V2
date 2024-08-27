import Foundation

import Domain

public struct AcademicScheduleDTOElement: Decodable {
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

extension AcademicScheduleDTOElement {
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


public typealias AcademicScheduleDTO = [AcademicScheduleDTOElement]

extension AcademicScheduleDTO {
    func toDomain() -> AcademicScheduleEntity {
        return self.map { $0.toDomain() }
    }
}
