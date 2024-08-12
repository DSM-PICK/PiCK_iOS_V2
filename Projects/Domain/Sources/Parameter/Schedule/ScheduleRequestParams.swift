import Foundation

public struct ScheduleRequestParams: Encodable {
    public let year: String
    public let month: String

    public init(year: String, month: String) {
        self.year = year
        self.month = month
    }

}
