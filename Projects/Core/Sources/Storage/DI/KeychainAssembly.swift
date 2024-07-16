import Swinject

public final class KeychainAssembly: Assembly {
    public init() {}

    public func assemble(container: Container) {
        container.register(Keychain.self) { _ in
            KeychainImpl()
        }
        
        container.register(UserDefault.self) { _ in
            UserDefaultsManager()
        }
    }
}
