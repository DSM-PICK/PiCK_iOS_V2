import Foundation

public struct ClassRoomMoveRequestParams: Encodable {
    public let floor: Int
    public let classroomName: String
    public let startPeriod: Int
    public let endPeriod: Int

    public init(
        floor: Int,
        classroomName: String,
        startPeriod: Int,
        endPeriod: Int
    ) {
        self.floor = floor
        self.classroomName = classroomName
        self.startPeriod = startPeriod
        self.endPeriod = endPeriod
    }

}
