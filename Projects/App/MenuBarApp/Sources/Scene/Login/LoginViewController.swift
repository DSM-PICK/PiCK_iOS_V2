import Cocoa
import MenuBarNetwork

final class LoginViewController: NSViewController {

    private let containerView: NSView = {
        let view = NSView()
        return view
    }()

    private let titleLabel: NSTextField = {
        let label = NSTextField(labelWithString: "PiCK 로그인")
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.alignment = .center
        return label
    }()

    private let idTextField: NSTextField = {
        let textField = NSTextField()
        textField.placeholderString = "아이디"
        textField.bezelStyle = .roundedBezel
        return textField
    }()

    private let passwordTextField: NSSecureTextField = {
        let textField = NSSecureTextField()
        textField.placeholderString = "비밀번호"
        textField.bezelStyle = .roundedBezel
        return textField
    }()

    private let loginButton: NSButton = {
        let button = NSButton(title: "로그인", target: nil, action: nil)
        button.bezelStyle = .rounded
        button.keyEquivalent = "\r"
        return button
    }()

    private let errorLabel: NSTextField = {
        let label = NSTextField(labelWithString: "")
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemRed
        label.alignment = .center
        label.isHidden = true
        return label
    }()

    var onLoginSuccess: (() -> Void)?

    override func loadView() {
        view = NSView(frame: NSRect(x: 0, y: 0, width: 300, height: 200))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }

    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(idTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(errorLabel)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        idTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            idTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            idTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            idTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            idTextField.heightAnchor.constraint(equalToConstant: 28),

            passwordTextField.topAnchor.constraint(equalTo: idTextField.bottomAnchor, constant: 12),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 28),

            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 100),

            errorLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 12),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    private func setupActions() {
        loginButton.target = self
        loginButton.action = #selector(loginButtonTapped)
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
