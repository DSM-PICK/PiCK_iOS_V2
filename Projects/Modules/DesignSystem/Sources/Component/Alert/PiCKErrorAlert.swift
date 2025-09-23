import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core

public class PiCKErrorToast: UIViewController {
    private let disposeBag = DisposeBag()

    private let backgroundView = UIView().then {
        $0.backgroundColor = .gray50
        $0.layer.cornerRadius = 24
    }
    private let imageView = UIImageView().then {
        $0.image = .failIcon
        $0.tintColor = .error
    }
    private let errorLabel = PiCKLabel(
        textColor: .modeBlack,
        font: .pickFont(.body1)
    )

    public init(message: String) {
        super.init(nibName: nil, bundle: nil)
        self.errorLabel.text = message
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupLayout()
        setupInitialPosition()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showToast()
    }

    private func setupLayout() {
        view.addSubview(backgroundView)

        [
            imageView,
            errorLabel
        ].forEach { backgroundView.addSubview($0) }

        backgroundView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(48)
        }
        imageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
        }
        errorLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(imageView.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().inset(16)
        }
    }

    private func setupInitialPosition() {
        backgroundView.transform = CGAffineTransform(translationX: 0, y: -100)
        backgroundView.alpha = 0
    }

    private func showToast() {
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: .curveEaseOut
        ) {
            self.backgroundView.transform = .identity
            self.backgroundView.alpha = 1
        } completion: { _ in
            self.hideToastAfterDelay()
        }
    }

    private func hideToastAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.hideToast()
        }
    }

    private func hideToast() {
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: .curveEaseIn
        ) {
            self.backgroundView.transform = CGAffineTransform(translationX: 0, y: -100)
            self.backgroundView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false)
        }
    }
}

public extension UIViewController {
    func presentErrorToast(message: String) {
        let toast = PiCKErrorToast(message: message)
        toast.modalPresentationStyle = .overFullScreen
        toast.modalTransitionStyle = .crossDissolve
        self.present(toast, animated: false)
    }
}
