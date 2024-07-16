import UIKit

public enum UserDefaultKeys: String {
    case displayMode = "displayMode"
}

public struct UserDefaultsManager: UserDefault {
    
    public static let shared = UserDefaultsManager()
    
    public func set<T>(to: T, forKey: UserDefaultKeys) {
        UserDefaults.standard.set(to, forKey: forKey.rawValue)
        print("UserDefaultsManager: save \(forKey) complete")
        print("\(UserDefaultsManager.shared.get(forKey: .displayMode))")
    }
    
    public func get(forKey: UserDefaultKeys) -> Any {
        return UserDefaults.standard.object(forKey: forKey.rawValue)!
    }
    
}
