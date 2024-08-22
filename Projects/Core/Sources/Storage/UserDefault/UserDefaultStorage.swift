import UIKit

public enum UserDefaultKeys: String {
    case homeViewMode = "homeViewMode"
    case displayMode = "displayMode"
}

public struct UserDefaultsManager: UserDefault {
    public static let shared = UserDefaultsManager()

    public func set<T>(to: T, forKey: UserDefaultKeys) {
        UserDefaults.standard.set(to, forKey: forKey.rawValue)
    }

    public func get(forKey: UserDefaultKeys) -> Any? {
        return UserDefaults.standard.object(forKey: forKey.rawValue)
    }

}
