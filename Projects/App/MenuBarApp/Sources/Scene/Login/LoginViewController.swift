import Cocoa
import SnapKit
import Then
import MenuBarNetwork
import MenuBarDesignSystem

final class LoginViewController: BaseNSViewController {
    private let titleLabel = NSTextField(labelWithString: "PiCK 로그인").then {
        $0.font = .systemFont(ofSize: 20, weight: .bold)
        $0.textColor = .pickModeBlack
        $0.alignment = .center
        $0.isEditable = false
        $0.isBordered = false
        $0.backgroundColor = .clear
    }

    private let idTextField = NSTextField().then {
        $0.placeholderString = "아이디"
        $0.bezelStyle = .roundedBezel
    }

    private let passwordTextField = NSSecureTextField().then {
        $0.placeholderString = "비밀번호"
        $0.bezelStyle = .roundedBezel
    }

    private let loginButton = NSButton(title: "로그인", target: nil, action: nil).then {
        $0.bezelStyle = .rounded
        $0.keyEquivalent = "\r"
    }

    private let errorLabel = NSTextField(labelWithString: "").then {
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .systemRed
        $0.alignment = .center
        $0.isEditable = false
        $0.isBordered = false
        $0.backgroundColor = .clear
        $0.isHidden = true
    }

    var onLoginSuccess: (() -> Void)?

    override func setupUI() {
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.pickBackground.cgColor

        view.addSubview(titleLabel)
        view.addSubview(idTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(errorLabel)

        loginButton.target = self
        loginButton.action = #selector(loginButtonTapped)
    }

    override func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
        }

        idTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(28)
        }

        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(idTextField.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(28)
        }

        loginButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(100)
        }

        errorLabel.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }

    @objc private func loginButtonTapped() {
        let accountID = idTextField.stringValue
        let password = passwordTextField.stringValue

        guard !accountID.isEmpty, !password.isEmpty else {
            showError("아이디와 비밀번호를 입력해주세요")
            return
        }

        loginButton.isEnabled = false
        errorLabel.isHidden = true

        Task {
            do {
                try await MenuBarService.shared.login(accountID: accountID, password: password)
                await MainActor.run {
                    onLoginSuccess?()
                }
            } catch {
                await MainActor.run {
                    loginButton.isEnabled = true
                    showError("로그인 실패: 아이디 또는 비밀번호를 확인해주세요")
                }
            }
        }
    }

    private func showError(_ message: String) {
        errorLabel.stringValue = message
        errorLabel.isHidden = false
    }
}
