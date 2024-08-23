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
    public func setUserDataType<T: Codable>(to: T, forKey: UserDefaultKeys) {
        let encoder = JSONEncoder()

        do {
            let encodedData = try encoder.encode(to)
            UserDefaults.standard.set(encodedData, forKey: forKey.rawValue)
        } catch {
            print("Fail To Encode UserDataType")
        }
    }

    public func get(forKey: UserDefaultKeys) -> Any? {
        return UserDefaults.standard.object(forKey: forKey.rawValue)
    }

    public func getUserDataType<T: Codable>(forKey: UserDefaultKeys, type: T.Type) -> Any? {
        let decoder = JSONDecoder()

        if let data = UserDefaults.standard.object(forKey: forKey.rawValue) {
            do {
                let decodedData = try decoder.decode(T.self, from: data as! Data)
                return decodedData
            } catch {
                print("Fail To Decode UserDataType")
            }
        }
        return nil
    }

}
