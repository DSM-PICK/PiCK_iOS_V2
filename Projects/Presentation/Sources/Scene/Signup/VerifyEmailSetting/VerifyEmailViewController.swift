import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import Core
import DesignSystem

public class VerifyEmailViewController: BaseReactorViewController<VerifyEmailReactor> {
    public func getCurrentEmailData() -> (email: String, verificationCode: String) {
        return (reactor.currentState.email, reactor.currentState.certification)
    }
    private let titleLabel = PiCKLabel(
        text: "PiCK에 회원가입하기",
        textColor: .modeBlack,
        font: .pickFont(.heading2)
    ).then {
        $0.changePointColor(targetString: "PiCK", color: .main500)
    }
    private let explainLabel = PiCKLabel(
        text: "DSM 이메일로 인증 해주세요.",
        textColor: .gray600,
        font: .pickFont(.body1)
    )
    private let emailTextField = PiCKTextField(
        titleText: "이메일",
        placeholder: "학교 이메일을 입력해주세요",
        buttonIsHidden: true,
        showEmailWithVerificationButton: true
    )
    private let certificationTextField = PiCKTextField(
        titleText: "인증 코드",
        placeholder: "인증 코드를 입력해주세요",
        buttonIsHidden: true
    )
    private let nextButton = PiCKButton(
        buttonText: "다음",
        isHidden: false
    )

    public override func attribute() {
        super.attribute()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    public override func bindAction() {
        emailTextField.rx.text.orEmpty.asDriver()
            .distinctUntilChanged()
            .map { VerifyEmailReactor.Action.updateEmail($0) }
            .drive(reactor.action)
            .disposed(by: disposeBag)

        certificationTextField.rx.text.orEmpty.asDriver()
            .distinctUntilChanged()
            .map { VerifyEmailReactor.Action.updateCertification($0) }
            .drive(reactor.action)
            .disposed(by: disposeBag)

        emailTextField.verificationButtonTapped.asDriver(onErrorJustReturn: ())
            .map { VerifyEmailReactor.Action.verificationButtonDidTap }
            .drive(reactor.action)
            .disposed(by: disposeBag)

        nextButton.buttonTap
            .asDriver()
            .map { VerifyEmailReactor.Action.nextButtonDidTap }
            .drive(reactor.action)
            .disposed(by: disposeBag)
    }

    public override func bindState() {
        reactor.state
            .map { $0.isNextButtonEnabled }
            .distinctUntilChanged()
            .withUnretained(self)
            .bind { owner, isEnabled in
                owner.nextButton.isEnabled = isEnabled
            }
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.verificationButtonText }
            .distinctUntilChanged()
            .withUnretained(self)
            .bind { owner, buttonText in
                owner.emailTextField.updateVerificationButtonText(buttonText)
            }
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.emailErrorDescription }
            .distinctUntilChanged()
            .filter { $0 != "" }
            .withUnretained(self)
            .bind { owner, errorMessage in
                owner.emailTextField.errorMessage.accept(errorMessage)
            }
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.certificationErrorDescription }
            .distinctUntilChanged()
            .filter { $0 != "" }
            .withUnretained(self)
            .bind { owner, errorMessage in
                owner.certificationTextField.errorMessage.accept(errorMessage)
            }
            .disposed(by: disposeBag)
    }

    public override func addView() {
        [
            titleLabel,
            explainLabel,
            emailTextField,
            certificationTextField,
            nextButton
        ].forEach { view.addSubview($0) }
    }

    public override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(80)
            $0.leading.equalToSuperview().inset(24)
        }
        explainLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(24)
        }
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(explainLabel.snp.bottom).offset(75)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(40)
        }
        certificationTextField.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(71)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(40)
        }
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    }
}
