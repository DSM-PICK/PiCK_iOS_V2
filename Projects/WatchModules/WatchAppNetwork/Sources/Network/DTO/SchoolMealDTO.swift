import Foundation

public struct SchoolMealDTO: Decodable, Hashable {
    public let date: String
    public let meals: SchoolMealDTOElement

    enum CodingKeys: String, CodingKey {
        case date
        case meals = "meal_list"
    }
}

public struct SchoolMealDTOElement: Decodable, Hashable {
   public let breakfast, lunch, dinner: MealDTOElement
}

public struct MealDTOElement: Decodable, Hashable {
    public let menu: [String]
    public let cal: String
}
