import Foundation

import RxSwift
import RxCocoa
import RxFlow

import Core
import Domain

import FirebaseMessaging

public class LoginViewModel: BaseViewModel, Stepper {
    private let disposeBag = DisposeBag()
    public var steps = PublishRelay<Step>()

    private let loginUseCase: LoginUseCase

    public init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
    }

    public struct Input {
        let idText: Observable<String>
        let passwordText: Observable<String>
        let clickLoginButton: Observable<Void>
    }
    public struct Output {
        let idErrorDescription: Signal<String?>
        let passwordErrorDescription: Signal<String?>
        let buttonEnabled: Driver<Bool>
    }

    private let passwordErrorDescription = PublishRelay<String?>()
    private let idErrorDescription = PublishRelay<String?>()

    public func transform(input: Input) -> Output {

        let buttonEnabled = Observable.combineLatest(
                input.idText,
                input.passwordText
            )
            .map { id, password in
                !id.isEmpty && !password.isEmpty
            }
            .asDriver(onErrorJustReturn: false)

        let info = Observable.combineLatest(input.idText, input.passwordText)

        input.clickLoginButton
            .withLatestFrom(info)
            .flatMap { id, password in
                self.loginUseCase.execute(req: .init(
                    accountID: id,
                    password: password,
                    deviceToken: Messaging.messaging().fcmToken ?? ""
                ))
                .catch {
                    print($0.localizedDescription)
                    self.idErrorDescription.accept("아이디를 다시 확인해주세요")
                    self.passwordErrorDescription.accept("비밀번호를 다시 확인해주세요")
                    return .never()
                }
                .andThen(Single.just(PiCKStep.tabIsRequired))
            }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output(
            idErrorDescription: idErrorDescription.asSignal(),
            passwordErrorDescription: passwordErrorDescription.asSignal(),
            buttonEnabled: buttonEnabled
        )
    }

}

extension LoginViewModel {
    private func checkLoginData(_ id: String, _ password: String) -> Bool {
        if id.isEmpty {
            idErrorDescription.accept("아이디를 입력해주세요")
        } else {
            idErrorDescription.accept(nil)
        }

        if password.isEmpty {
            passwordErrorDescription.accept("비밀번호를 입력해주세요")
        } else {
            passwordErrorDescription.accept(nil)
        }

        return !id.isEmpty && !password.isEmpty
    }
}
