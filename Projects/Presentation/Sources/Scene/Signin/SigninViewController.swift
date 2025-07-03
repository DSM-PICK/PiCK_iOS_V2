import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import DesignSystem

public class LoginViewController: BaseReactorViewController<SigninReactor> {
    private let titleLabel = PiCKLabel(
        text: "PiCK에 로그인하기",
        textColor: .modeBlack,
        font: .pickFont(.heading2)
    ).then {
        $0.changePointColor(targetString: "PiCK", color: .main500)
    }
    private let explainLabel = PiCKLabel(
        text: "PiCK 계정으로 로그인 해주세요.",
        textColor: .gray600,
        font: .pickFont(.body1)
    )
    private let idTextField = PiCKTextField(
        titleText: "아이디",
        placeholder: "아이디를 입력해주세요",
        buttonIsHidden: true
    )
    private let passwordTextField = PiCKTextField(
        titleText: "비밀번호",
        placeholder: "비밀번호를 입력해주세요",
        buttonIsHidden: false
    ).then {
        $0.isSecurity = true
    }
    private let forgotPasswordButton = PiCKUnderlineButton(
        buttonText: "비밀번호 변경"
    )
    private let forgotPasswordLabel = PiCKLabel(
        text: "비밀번호를 잊어버리셨나요?",
        textColor: .gray900,
        font: .pickFont(.body1)
    )
    private let nonAccountLabel = PiCKLabel(
        text: "PiCK 계정이 없으신가요?",
        textColor: .gray900,
        font: .pickFont(.body1)
    )
    private let nonAccountButton = PiCKUnderlineButton(
        buttonText: "회원가입"
    )
    private let loginButton = PiCKButton(
        buttonText: "로그인하기",
        isHidden: false,
    )

    public override func attribute() {
        super.attribute()

        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    public override func bindAction() {
        idTextField.rx.text.orEmpty.asDriver()
            .distinctUntilChanged()
            .map { SigninReactor.Action.updateID($0) }
            .drive(reactor.action)
            .disposed(by: disposeBag)

        passwordTextField.rx.text.orEmpty.asDriver()
            .distinctUntilChanged()
            .map { SigninReactor.Action.updatePassword($0) }
            .drive(reactor.action)
            .disposed(by: disposeBag)

        loginButton.buttonTap
            .asDriver()
            .map { SigninReactor.Action.loginButtonDidTap }
            .drive(reactor.action)
            .disposed(by: disposeBag)

        nonAccountButton.buttonTap
            .asDriver()
            .map { SigninReactor.Action.signUpButtonDidTap }
            .drive(reactor.action)
            .disposed(by: disposeBag)
    }
    public override func bindState() {
        reactor.state
            .map { $0.idErrorDescription }
            .distinctUntilChanged()
            .filter { $0 != "" }
            .withUnretained(self)
            .bind { onwer, errorMessage in
                onwer.idTextField.errorMessage.accept(errorMessage)
            }.disposed(by: disposeBag)

        reactor.state
            .map { $0.passwordErrorDescription }
            .distinctUntilChanged()
            .filter { $0 != "" }
            .withUnretained(self)
            .bind { onwer, errorMessage in
                onwer.passwordTextField.errorMessage.accept(errorMessage)
            }.disposed(by: disposeBag)

        reactor.state
            .map { $0.isButtonEnabled }
            .distinctUntilChanged()
            .withUnretained(self)
            .bind { owner, isEnabled in
                owner.loginButton.isEnabled = isEnabled
            }.disposed(by: disposeBag)
    }
    public override func addView() {
        [
            titleLabel,
            explainLabel,
            idTextField,
            passwordTextField,
            forgotPasswordButton,
            forgotPasswordLabel,
            nonAccountLabel,
            nonAccountButton,
            loginButton
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
        idTextField.snp.makeConstraints {
            $0.top.equalTo(explainLabel.snp.bottom).offset(75)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(40)
        }
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(idTextField.snp.bottom).offset(71)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(40)
        }
        forgotPasswordButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(12)
            $0.trailing.equalToSuperview().inset(24)
        }
        forgotPasswordLabel.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(12)
            $0.trailing.equalTo(forgotPasswordButton.snp.leading).offset(-4)
        }
        nonAccountLabel.snp.makeConstraints {
            $0.bottom.equalTo(loginButton.snp.top).offset(-12)
            $0.leading.equalToSuperview().inset(24)
        }
        nonAccountButton.snp.makeConstraints {
            $0.bottom.equalTo(loginButton.snp.top).offset(-12)
            $0.leading.equalTo(nonAccountLabel.snp.trailing).offset(4)
        }
        loginButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    }
}
