import Foundation

import RxSwift
import RxCocoa
import RxFlow

import Core
import Domain

public class OnboardingViewModel: BaseViewModel, Stepper {
    
    private let disposeBag = DisposeBag()
    public var steps = PublishRelay<Step>()

    private let refreshTokenUseCase: RefreshTokenUseCase
    
    public init(refreshTokenUseCase: RefreshTokenUseCase) {
        self.refreshTokenUseCase = refreshTokenUseCase
    }
    
    public struct Input {
        let viewWillAppear: Observable<Void>
        let clickOnboardingButton: Observable<Void>
    }
    public struct Output {}
    
    public func transform(input: Input) -> Output {
        input.viewWillAppear.asObservable()
//            .map { _ in animate.accept(()) }
            .flatMap { [self] in
                return refreshTokenUseCase.execute()
//                    .asCompletable()
                    .catch { _ in
//                        showNavigationButton.accept(())
                        return .never()
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
