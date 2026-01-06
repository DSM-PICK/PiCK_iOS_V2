import Foundation

public struct ClassroomMoveRequestParams: Encodable {
    public let move: String
    public let floor: Int
    public let classroomName: String
    public let startPeriod: Int
    public let endPeriod: Int

    public init(
        move: String,
        floor: Int,
        classroomName: String,
        startPeriod: Int,
        endPeriod: Int
    ) {
        self.move = move
        self.floor = floor
        self.classroomName = classroomName
        self.startPeriod = startPeriod
        self.endPeriod = endPeriod
    }

    enum CodingKeys: String, CodingKey {
        case move
        case floor
        case classroomName = "classroom_name"
        case startPeriod = "start"
        case endPeriod = "end"
    }

}
