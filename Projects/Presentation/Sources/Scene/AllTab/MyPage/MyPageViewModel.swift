import Foundation

import RxSwift
import RxCocoa
import RxFlow

import Core
import Domain

public class MyPageViewModel: BaseViewModel, Stepper {
    private let disposeBag = DisposeBag()
    public var steps = PublishRelay<Step>()

    private let fetchProfileUsecase: FetchDetailProfileUseCase
    private let uploadProfileImageUseCase: UploadProfileImageUseCase

    public init(
        profileUsecase: FetchDetailProfileUseCase,
        uploadProfileImageUseCase: UploadProfileImageUseCase
    ) {
        self.fetchProfileUsecase = profileUsecase
        self.uploadProfileImageUseCase = uploadProfileImageUseCase
    }

    public struct Input {
        let viewWillAppear: Observable<Void>
        let profileImage: Observable<Data>
    }
    public struct Output {
        let profileData: Signal<DetailProfileEntity>
    }

    private let profileData = PublishRelay<DetailProfileEntity>()

    public func transform(input: Input) -> Output {
        input.viewWillAppear
            .flatMap {
                self.fetchProfileUsecase.execute()
                    .catch {
                        print($0.localizedDescription)
                        return .never()
                    }
            }
            .bind(to: profileData)
            .disposed(by: disposeBag)

        input.profileImage
            .flatMap { image in
                self.uploadProfileImageUseCase.execute(image: image)
                    .catch {
                        print($0.localizedDescription)
                        return .never()
                    }
            }
            .subscribe()
            .disposed(by: disposeBag)

        return Output(profileData: profileData.asSignal())
    }

}
