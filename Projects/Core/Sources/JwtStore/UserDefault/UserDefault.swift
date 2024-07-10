import Foundation

public protocol UserDefault {
    func set<T>(to: T, forKey: UserDefaultKeys)
    func get(forKey: UserDefaultKeys) -> Any
}
