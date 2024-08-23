import Foundation

import Domain

public struct SelfStudyTeacherDTOElement: Decodable {
    let floor: Int
    let teacherName: String
    
    enum CodingKeys: String, CodingKey {
        case floor
        case teacherName = "teacher_name"
    }
    
}

extension SelfStudyTeacherDTOElement {
    func toDomain() -> SelfStudyEntityElement {
        return .init(
            floor: floor,
            teacherName: teacherName
        )
    }
    
}


public typealias SelfStudyTeacherDTO = [SelfStudyTeacherDTOElement]

extension SelfStudyTeacherDTO {
    func toDomain() -> SelfStudyEntity {
        return self.map { $0.toDomain() }
    }
}
