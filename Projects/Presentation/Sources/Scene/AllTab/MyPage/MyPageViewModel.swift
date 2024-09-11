import Foundation

import RxSwift
import RxCocoa
import RxFlow

import Core
import Domain

public class MyPageViewModel: BaseViewModel, Stepper {
    private let disposeBag = DisposeBag()
    public var steps = PublishRelay<Step>()

    private let profileUsecase: FetchDetailProfileUseCase

    public init(profileUsecase: FetchDetailProfileUseCase) {
        self.profileUsecase = profileUsecase
    }

    public struct Input {
        let viewWillAppear: Observable<Void>
    }
    public struct Output {
        let profileData: Signal<DetailProfileEntity>
    }

    private let profileData = PublishRelay<DetailProfileEntity>()

    public func transform(input: Input) -> Output {
        input.viewWillAppear
            .flatMap {
                self.profileUsecase.execute()
                    .catch {
                        print($0.localizedDescription)
                        return .never()
                    }
            }
            .bind(to: profileData)
            .disposed(by: disposeBag)

        return Output(profileData: profileData.asSignal())
    }

}
