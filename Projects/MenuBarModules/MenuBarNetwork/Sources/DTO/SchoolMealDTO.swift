import Foundation

public struct SchoolMealDTO: Decodable {
    public let date: String
    public let meals: SchoolMealDTOElement

    enum CodingKeys: String, CodingKey {
        case date
        case meals = "meal_list"
    }
}

public struct SchoolMealDTOElement: Decodable {
    public let breakfast, lunch, dinner: MealDTOElement
}

public struct MealDTOElement: Decodable {
    public let menu: [String]
    public let cal: String
}
