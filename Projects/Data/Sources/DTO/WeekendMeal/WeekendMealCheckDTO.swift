import Foundation

import Core
import Domain

public struct WeekendMealCheckDTO: Decodable {
    let status: String
    
}

extension WeekendMealCheckDTO {
    func toDomain() -> WeekendMealCheckEntity {
        return .init(status: status)
    }
    
}
