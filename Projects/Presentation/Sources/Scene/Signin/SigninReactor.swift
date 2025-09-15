import Foundation

import RxSwift
import RxCocoa
import RxFlow

import ReactorKit

import Core
import Domain

import FirebaseMessaging

public final class SigninReactor: BaseReactor {
    private let disposeBag = DisposeBag()
    public var steps = PublishRelay<Step>()
    public let initialState: State

    private let signinUseCase: SigninUseCase

    init(signinUseCase: SigninUseCase) {
        self.initialState = .init()
        self.signinUseCase = signinUseCase
    }

    public enum Action {
        case updateID(String)
        case updatePassword(String)
        case loginButtonDidTap
        case signupButtonDidTap
        case forgotPasswordButtonDidTap
    }

    public enum Mutation {
        case updateID(String)
        case updatePassword(String)
        case idError(String)
        case passwordError(String)
        case errorReset
        case isButtonEnabled(Bool)
        case loginSuccess
        case navigateToSignup
        case navigateToChangePassword
    }

    public struct State {
        var id: String = ""
        var password: String = ""
        var idErrorDescription: String = ""
        var passwordErrorDescription: String = ""
        var isButtonEnabled: Bool = false
    }
}

extension SigninReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loginButtonDidTap:
            return .concat([
                loginButtonDidTap(
                    id: self.currentState.id,
                    password: self.currentState.password
                ),
                .just(.errorReset)
            ])
        case .updateID(let id):
            let enabled = !id.isEmpty && !self.currentState.password.isEmpty
            return .concat([
                .just(.isButtonEnabled(enabled)),
                .just(.updateID(id))
            ])
        case .updatePassword(let password):
            let enabled = !self.currentState.id.isEmpty && !password.isEmpty
            return .concat([
                .just(.isButtonEnabled(enabled)),
                .just(.updatePassword(password))
            ])
        case .signupButtonDidTap:
            return .just(.navigateToSignup)
        case .forgotPasswordButtonDidTap:
            return .just(.navigateToChangePassword)
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .updateID(let id):
            newState.id = id
        case .updatePassword(let password):
            newState.password = password
        case .idError(let error):
            newState.idErrorDescription = error
        case .passwordError(let error):
            newState.passwordErrorDescription = error
        case .errorReset:
            newState.idErrorDescription = ""
            newState.passwordErrorDescription = ""
        case .isButtonEnabled(let enabled):
            newState.isButtonEnabled = enabled
        case .loginSuccess:
            steps.accept(PiCKStep.tabIsRequired)
        case .navigateToSignup:
            steps.accept(PiCKStep.verifyEmailIsRequired)
        case .navigateToChangePassword:
            steps.accept(PiCKStep.changePasswordIsRequired)
        }
        return newState
    }

    private func loginButtonDidTap(id: String, password: String) -> Observable<Mutation> {
        return self.signinUseCase.execute(req: .init(
            accountID: id,
            password: password,
            deviceToken: Messaging.messaging().fcmToken ?? ""
        ))
        .andThen(Observable.just(Mutation.loginSuccess))
        .catch { error in
            guard let error = error as? AuthError,
                    let description = error.errorDescription
            else { return .never() }
            switch error {
            case .idMismatch:
                return .just(.idError(description))
            case .passwordMismatch:
                return .just(.passwordError(description))
            }
        }
    }
}
