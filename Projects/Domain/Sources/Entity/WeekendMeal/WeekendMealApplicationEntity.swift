import Foundation

import Core

public struct WeekendMealApplicationEntity {
    public let isApplicable: Bool
    public let month: Int?

    public init(
        isApplicable: Bool,
        month: Int?
    ) {
        self.isApplicable = isApplicable
        self.month = month
    }

}
