import Foundation

import Domain

struct SchoolMealDTO: Decodable {
    public let date: String
    public let meals: [SchoolMealDTOElement]
}

extension SchoolMealDTO {
    func toDomain() -> SchoolMealEntity {
//        return .init(meals: meals.toDomain())
        return .init(
            date: date,
            meals: meals.map { $0.toDomain() }
        )
    }
}

struct SchoolMealDTOElement: Decodable {
   public let breakfast: [String]
   public let lunch: [String]
   public let dinner: [String]
}

extension SchoolMealDTOElement {
    func toDomain() -> SchoolMealEntityElement {
        return .init(
            breakfast: breakfast,
            lunch: lunch,
            dinner: dinner
        )
//        return .init(
//            mealBundle: [
//                (0, "조식", breakfast),
//                (1, "중식", lunch),
//                (2, "석식", dinner)
//            ]
//        )
    }
    
}
