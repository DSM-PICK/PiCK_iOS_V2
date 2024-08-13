import Foundation

import Domain

import Swinject

public final class UseCaseAssembly: Assembly {
    public init() {}

    public func assemble(container: Container) {
        //MARK: Auth
        container.register(LoginUseCase.self) { resolver in
            LoginUseCase(repository: resolver.resolve(AuthRepository.self)!)
        }
        container.register(RefreshTokenUseCase.self) { resolver in
            RefreshTokenUseCase(repository: resolver.resolve(AuthRepository.self)!)
        }

        //MARK: AllTab
        container.register(FetchDetailProfileUseCase.self) { resolver in
            FetchDetailProfileUseCase(repository: resolver.resolve(ProfileRepository.self)!)
        }

        //MARK: Notice
        container.register(FetchNoticeListUseCase.self) { resolver in
            FetchNoticeListUseCase(repository: resolver.resolve(NoticeRepository.self)!)
        }

    }

}
