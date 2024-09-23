import Foundation

import RxSwift
import RxCocoa
import RxFlow

import Core
import Domain

public class SelfStudyViewModel: BaseViewModel, Stepper {
    private let disposeBag = DisposeBag()
    public var steps = PublishRelay<Step>()

    private let fetchSelfStudyUseCase: FetchSelfStudyUseCase

    public init(fetchSelfStudyUseCase: FetchSelfStudyUseCase) {
        self.fetchSelfStudyUseCase = fetchSelfStudyUseCase
    }

    public struct Input {
        let selfStudyDate: Observable<String>
    }
    public struct Output {
        let selfStudyData: Driver<SelfStudyEntity>
    }

    private let selfStudyData = BehaviorRelay<SelfStudyEntity>(value: [])

    public func transform(input: Input) -> Output {
        input.selfStudyDate
            .flatMap { date in
                self.fetchSelfStudyUseCase.execute(date: date)
                    .catch {
                        print($0.localizedDescription)
                        return .never()
                    }
            }
            .bind(to: selfStudyData)
            .disposed(by: disposeBag)

        return Output(selfStudyData: selfStudyData.asDriver())
    }

}
