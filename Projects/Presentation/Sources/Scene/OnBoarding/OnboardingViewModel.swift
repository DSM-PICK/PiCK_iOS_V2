import Foundation

import RxSwift
import RxCocoa
import RxFlow

import Core
import Domain

public class OnboardingViewModel: BaseViewModel, Stepper {
    
    private let disposeBag = DisposeBag()
    public var steps = PublishRelay<Step>()
    
    public init() {}
    
    public struct Input {
//        let viewWillAppear: Observable<Void>
//        let componentAppear: Observable<Void>
        let loginButtonDidClick: Observable<Void>
    }
    public struct Output {
//        let animate: Signal<Void>
//        let showComponet: Signal<Void>
    }
    
//    let animate = PublishRelay<Void>()
//    let showComponet = PublishRelay<Void>()
    
    public func transform(input: Input) -> Output {
        
//        input.viewWillAppear.asObservable()
//            .map { _ in self.animate.accept(()) }
//            .bind(to: animate)
//            .disposed(by: disposeBag)
//        
//        input.componentAppear.asObservable()
//            .throttle(.seconds(2), scheduler: MainScheduler.asyncInstance)
//            .map { _ in self.showComponet.accept(()) }
//            .bind(to: showComponet)
//            .disposed(by: disposeBag)
        
        input.loginButtonDidClick
            .map { PiCKStep.loginIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)
        
        
        return Output(
//            animate: animate.asSignal(),
//            showComponet: showComponet.asSignal()
        )
    }
    
}
