import Core
import DesignSystem
import RxFlow
import RxSwift
import RxCocoa
import Domain

public final class VerifyEmailViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()

    init(

    ) {

    }

    public struct Input {

    }

    public struct Output {

    }

    public func transform(input: Input) -> Output {
        return Output()
    }
}
