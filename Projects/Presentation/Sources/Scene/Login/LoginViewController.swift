import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import DesignSystem

public class LoginViewController: BaseViewController<LoginViewModel> {
    
    private let titleLabel = UILabel().then {
        $0.text = "PiCK에 로그인하기"
        $0.textColor = .modeBlack
        $0.changePointColor(targetString: "PiCK", color: .main500)
        $0.font = .heading2
    }
    private let explainLabel = UILabel().then {
        $0.text = "스퀘어 계정으로 로그인 해주세요."
        $0.textColor = .gray600
        $0.font = .body1
    }
    private let loginTextField = PiCKTextField(
        titleText: "아이디",
        placeholder: "아이디를 입력해주세요",
        isHidden: true
    )
    private let passwordTextField = PiCKTextField(
        titleText: "비밀번호",
        placeholder: "비밀번호를 입력해주세요",
        isHidden: false
    ).then {
        $0.isSecurity = true
    }
    private let loginButton = PiCKButton(type: .system, buttonText: "로그인하기")
    
    public override func attribute() {
        super.attribute()
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    public override func bind() {
        let input = LoginViewModel.Input(
            clickLoginButton: loginButton.buttonTap.asObservable()
        )
        _ = viewModel.transform(input: input)
    }
    
    public override func addView() {
        [
            titleLabel,
            explainLabel,
            loginTextField,
            passwordTextField,
            loginButton
        ].forEach { view.addSubview($0) }
    }
    
    public override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(124)
            $0.leading.equalToSuperview().inset(24)
        }
        explainLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(24)
        }
        loginTextField.snp.makeConstraints {
            $0.top.equalTo(explainLabel.snp.bottom).offset(75)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(40)
        }
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(loginTextField.snp.bottom).offset(71)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(40)
        }
        loginButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
}
