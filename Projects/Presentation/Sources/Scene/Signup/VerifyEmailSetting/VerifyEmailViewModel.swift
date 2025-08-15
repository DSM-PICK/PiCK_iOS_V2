import Core
import DesignSystem
import RxFlow
import RxSwift
import RxCocoa
import Domain

public class VerifyEmailViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()
    private let verifyEmailCodeUseCase: VerifyEmailCodeUseCase
    public init(verifyEmailCodeUseCase: VerifyEmailCodeUseCase) {
        self.verifyEmailCodeUseCase = verifyEmailCodeUseCase
    }

    public struct Input {
        let nextButtonTap: Observable<Void>
        let emailText: Observable<String>
        let certificationText: Observable<String>
        let verificationButtonTap: Observable<Void>
    }

    public struct Output {
        let isNextButtonEnabled: Observable<Bool>
    }

    public func transform(input: Input) -> Output {
        let isFormValid = Observable.combineLatest(
            input.emailText,
            input.certificationText
        ) { email, certification in
            return !email.isEmpty && !certification.isEmpty
        }

        input.verificationButtonTap
            .do(onNext: { print("🔵 인증 버튼 탭됨") })
            .withLatestFrom(input.emailText)
            .do(onNext: { email in print("🔵 현재 이메일: \(email)") })
            .filter { !$0.isEmpty }
            .do(onNext: { email in print("🔵 이메일 필터 통과: \(email)") })
            .flatMap { email in
                print("🔵 API 요청 시작")
                return self.verifyEmailCodeUseCase.execute(
                    req: VerifyEmailCodeRequestParams(
                        mail: "\(email)",
                        message: "아래 인증번호를 진행 인증 화면에 입력해주세요",
                        title: "회원가입 제목 테스트"
                    )
                )
                .do(onCompleted: { print("🔵 API 요청 완료") })
                .catch { error in
                    print("🔴 인증코드 전송 실패: \(error.localizedDescription)")
                    return .never()
                }
            }
            .subscribe(onCompleted: {
                print("🎉 인증코드 전송 성공")
            })
            .disposed(by: disposeBag)

        input.nextButtonTap
            .withLatestFrom(isFormValid)
            .filter { $0 }
            .map { _ in PiCKStep.passwordSettingIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output(
            isNextButtonEnabled: isFormValid
        )
    }
}
