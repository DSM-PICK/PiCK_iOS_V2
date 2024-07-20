import Foundation

import Domain

import Swinject

public final class UseCaseAssembly: Assembly {
    public init() {}

    public func assemble(container: Container) {
        container.register(LoginUseCase.self) { resolver in
            LoginUseCase(repository: resolver.resolve(AuthRepository.self)!)
        }

//        container.register(VerifyAuthCodeUseCase.self) { resolver in
//            VerifyAuthCodeUseCase(
//                authRepository: resolver.resolve(AuthRepository.self)!
//            )
//        }
    }
}
