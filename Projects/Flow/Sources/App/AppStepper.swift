import Foundation

import RxSwift
import RxCocoa
import RxFlow

import Core

public final class AppStepper: Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()

    public init() {
        setupNotificationObserver()
    }

    public var initialStep: Step {
        return PiCKStep.onboardingIsRequired
    }

    private func setupNotificationObserver() {
        NotificationCenter.default.rx
            .notification(.autoLoginDidFail)
            .map { _ in PiCKStep.onboardingIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)
    }
}
