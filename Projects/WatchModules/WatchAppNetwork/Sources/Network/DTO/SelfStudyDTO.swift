import Foundation

public struct SelfStudyTeacherDTOElement: Decodable, Hashable {
    public let floor: Int
    public let teacherName: String

    enum CodingKeys: String, CodingKey {
        case floor
        case teacherName = "teacher_name"
    }

}

public typealias SelfStudyTeacherDTO = [SelfStudyTeacherDTOElement]
