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
        case signinButtonDidTap
        case signupButtonDidTap
        case forgotPasswordButtonDidTap
    }

    public enum Mutation {
        case updateID(String)
        case updatePassword(String)
        case errorReset
        case isButtonEnabled(Bool)
        case signinSuccess
        case navigateToSignup
        case navigateToChangePassword
        case showErrorToast(String)
    }

    public struct State {
        var id: String = ""
        var password: String = ""
        var isButtonEnabled: Bool = false
        var errorToastMessage: String = ""
    }
}

extension SigninReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .signinButtonDidTap:
            return .concat([
                signinButtonDidTap(
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
        case .errorReset:
            newState.errorToastMessage = ""
        case .isButtonEnabled(let enabled):
            newState.isButtonEnabled = enabled
        case .signinSuccess:
            steps.accept(PiCKStep.tabIsRequired)
        case .navigateToSignup:
            steps.accept(PiCKStep.verifyEmailIsRequired)
        case .navigateToChangePassword:
            steps.accept(PiCKStep.changePasswordIsRequired)
        case .showErrorToast(let message):
            newState.errorToastMessage = message
        }
        return newState
    }

    private func signinButtonDidTap(id: String, password: String) -> Observable<Mutation> {
        return self.signinUseCase.execute(req: .init(
            accountID: id,
            password: password,
            deviceToken: Messaging.messaging().fcmToken ?? ""
        ))
        .andThen(Observable.just(Mutation.signinSuccess))
        .catch { error in
            guard let error = error as? AuthError else {
                return .just(.showErrorToast("네트워크 오류가 발생했습니다"))
            }
            return .just(.showErrorToast(error.localizedDescription))
        }
    }
}
