import Foundation

import RxSwift
import RxCocoa
import RxFlow

import Core
import Domain

import FirebaseMessaging

public class OnboardingViewModel: BaseViewModel, Stepper {
    private let disposeBag = DisposeBag()
    public var steps = PublishRelay<Step>()

    private let keychain = KeychainImpl()

    private let refreshTokenUseCase: RefreshTokenUseCase
    private let loginUseCase: LoginUseCase

    public init(
        refreshTokenUseCase: RefreshTokenUseCase,
        loginUseCase: LoginUseCase
    ) {
        self.refreshTokenUseCase = refreshTokenUseCase
        self.loginUseCase = loginUseCase
    }

    public struct Input {
        let viewWillAppear: Observable<Void>
        let clickOnboardingButton: Observable<Void>
    }
    public struct Output {}

    public func transform(input: Input) -> Output {
        input.viewWillAppear
            .flatMap {
                 self.refreshTokenUseCase.execute()
                     .catch {
                         print($0.localizedDescription)

                         return self.loginUseCase.execute(req: .init(
                             accountID: self.keychain.load(type: .id),
                             password: self.keychain.load(type: .password),
                             deviceToken: Messaging.messaging().fcmToken ?? ""
                         ))
                         .catch {
                             print($0.localizedDescription)
                             return .never()
                         }
                     }
                     .andThen(Single.just(PiCKStep.tabIsRequired))
             }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.clickOnboardingButton
            .map { PiCKStep.loginIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output()
    }

}
