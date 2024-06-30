import Foundation

import Core
import Domain

import Swinject

public final class PresentationAssembly: Assembly {
    public init() {}

    public func assemble(container: Container) {
        //onboarding
//        container.register(OnboardingViewController.self) { resolver in
//            OnboardingViewController(viewModel: resolver.resolve(OnboardingViewModel.self)!)
//        }
//        container.register(OnboardingViewModel.self) { resolver in
//            OnboardingViewModel()
//        }
//        
//        //login
//        container.register(LoginViewController.self) { resolver in
//            LoginViewController(viewModel: resolver.resolve(LoginViewModel.self)!)
//        }
//        container.register(LoginViewModel.self) { resolver in
//            LoginViewModel()
//        }
    }
    
}
