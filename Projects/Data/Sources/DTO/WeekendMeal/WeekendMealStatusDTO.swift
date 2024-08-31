import Foundation

import Core
import Domain

public struct WeekendMealStatusDTO: Decodable {
    let status: WeekendMealType.RawValue
}

extension WeekendMealStatusDTO {
    func toDomain() -> WeekendMealStatusEntity {
        return .init(status: status)
    }
}
