import Foundation

import RxSwift
import RxCocoa
import RxFlow

import Core
import Domain

public class SchoolMealViewModel: BaseViewModel, Stepper {
    private let disposeBag = DisposeBag()
    public var steps = PublishRelay<Step>()

    private let fetchSchoolMealUseCase: FetchSchoolMealUseCase

    public init(
        fetchSchoolMealUseCase: FetchSchoolMealUseCase
    ) {
        self.fetchSchoolMealUseCase = fetchSchoolMealUseCase
    }

    public struct Input {
        let schoolMealDate: Observable<String>
    }
    public struct Output {
        let schoolMealData: Driver<[(Int, String, MealEntityElement)]>
    }

    private let schoolMealData = BehaviorRelay<[(Int, String, MealEntityElement)]>(value: [])

    public func transform(input: Input) -> Output {
        input.schoolMealDate
            .flatMap { date in
                self.fetchSchoolMealUseCase.execute(date: date)
                    .catch {
                        print($0.localizedDescription)
                        return .never()
                    }
            }
            .subscribe(onNext: { [weak self] data in
                self?.schoolMealData.accept(data.meals.mealBundle)
            })
            .disposed(by: disposeBag)

        return Output(schoolMealData: schoolMealData.asDriver())
    }

}
