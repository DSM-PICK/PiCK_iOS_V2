import Foundation

import RxSwift
import RxCocoa
import RxFlow

import Core

public final class AppStepper: Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()

    public init() {}

    public var initialStep: Step {
        return PiCKStep.loginIsRequired
    }
}
