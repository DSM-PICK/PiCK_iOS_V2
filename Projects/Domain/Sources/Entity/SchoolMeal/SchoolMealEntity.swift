import Foundation

public struct SchoolMealEntity {
    public let meals: SchoolMealEntityElement
    
    public init(meals: SchoolMealEntityElement) {
        self.meals = meals
    }
    
}

public struct SchoolMealEntityElement {
    public let mealBundle: [(Int, String, [String])]

    public init(mealBundle: [(Int, String, [String])]) {
        self.mealBundle = mealBundle
    }
    
}
