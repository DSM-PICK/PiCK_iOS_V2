import Foundation

import Domain

import Swinject

public final class UseCaseAssembly: Assembly {
    public init() {}

    public func assemble(container: Container) {
        //MARK: Login
        container.register(LoginUseCase.self) { resolver in
            LoginUseCase(repository: resolver.resolve(AuthRepository.self)!)
        }

        //MARK: AllTab
        container.register(FetchDetailProfileUseCase.self) { resolver in
            FetchDetailProfileUseCase(repository: resolver.resolve(ProfileRepository.self)!)
        }

    }

}
