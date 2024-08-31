import Foundation

import Core

public struct WeekendMealStatusEntity {
    public let status: WeekendMealType.RawValue

    public init(status: WeekendMealType.RawValue) {
        self.status = status
    }

}
