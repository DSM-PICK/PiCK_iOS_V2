import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import DesignSystem

public class LoginViewController: BaseViewController<LoginViewModel> {
    private let titleLabel = PiCKLabel(
        text: "PiCK에 로그인하기",
        textColor: .modeBlack,
        font: .pickFont(.heading2)
    ).then {
        $0.changePointColor(targetString: "PiCK", color: .main500)
    }
    private let explainLabel = PiCKLabel(
        text: "스퀘어 계정으로 로그인 해주세요.",
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
    private let loginButton = PiCKButton(
        buttonText: "로그인하기",
        isHidden: false
    )

    public override func attribute() {
        super.attribute()

        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    public override func bind() {
        let input = LoginViewModel.Input(
            idText: idTextField.rx.text.orEmpty.asObservable(),
            passwordText: passwordTextField.rx.text.orEmpty.asObservable(),
            clickLoginButton: loginButton.buttonTap.asObservable()
        )
        let output = viewModel.transform(input: input)

        output.idErrorDescription.asObservable()
            .bind(to: self.idTextField.errorMessage)
            .disposed(by: disposeBag)

        output.passwordErrorDescription.asObservable()
            .bind(to: self.passwordTextField.errorMessage)
            .disposed(by: disposeBag)

        output.buttonEnabled
            .drive(loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    public override func addView() {
        [
            titleLabel,
            explainLabel,
            idTextField,
            passwordTextField,
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
        loginButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    }

}
