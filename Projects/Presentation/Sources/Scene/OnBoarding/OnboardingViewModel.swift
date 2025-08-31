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
    private let signinUseCase: SigninUseCase

    public init(
        refreshTokenUseCase: RefreshTokenUseCase,
        signinUseCase: SigninUseCase
    ) {
        self.refreshTokenUseCase = refreshTokenUseCase
        self.signinUseCase = signinUseCase
    }

    public struct Input {
        let viewWillAppear: Observable<Void>
        let componentAppear: Observable<Void>
        let onboardingButtonDidTap: Observable<Void>
    }
    public struct Output {
        let animate: Signal<Void>
        let showComponet: Signal<Void>
        let presentAlert: Signal<Void>
    }

    private let animate = PublishRelay<Void>()
    private let showComponent = PublishRelay<Void>()
    private let presentAlert = PublishRelay<Void>()

    public func transform(input: Input) -> Output {
        input.viewWillAppear
            .flatMap {
                self.refreshTokenUseCase.execute()
                    .catch { _ in
                        return self.signinUseCase.execute(req: .init(
                            accountID: self.keychain.load(type: .id),
                            password: self.keychain.load(type: .password),
                            deviceToken: Messaging.messaging().fcmToken ?? ""
                        ))
                        .catch { error in
                            guard let error = error as? PiCKError
                            else { return .never() }

                            switch error {
                            case .serverError:
                                self.presentAlert.accept(())
                                return .never()
                            default:
                                return .never()
                            }
                        }
                    }
                    .andThen(Single.just(PiCKStep.tabIsRequired))
            }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.viewWillAppear
            .map { _ in self.animate.accept(()) }
            .bind(to: animate)
            .disposed(by: disposeBag)

        input.componentAppear.asObservable()
            .throttle(.seconds(2), scheduler: MainScheduler.asyncInstance)
            .map { _ in self.showComponent.accept(()) }
            .bind(to: showComponent)
            .disposed(by: disposeBag)

        input.onboardingButtonDidTap
            .map { PiCKStep.loginIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output(
            animate: animate.asSignal(),
            showComponet: showComponent.asSignal(),
            presentAlert: presentAlert.asSignal()
        )
    }

}
