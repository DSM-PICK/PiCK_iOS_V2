import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core

public class PiCKTextField: BaseTextField {
    public var errorMessage = PublishRelay<String?>()

    public var isSecurity: Bool = false {
        didSet {
            textHideButton.isHidden = !isSecurity
            self.isSecureTextEntry = true
            self.addLeftAndRightView()
        }
    }
    private var borderColor: UIColor {
        isEditing ? .main500 : .clear
    }

    private let titleLabel = PiCKLabel(
        textColor: .modeBlack,
        font: .pickFont(.label1)
    )
    private let textHideButton = UIButton(type: .system).then {
        $0.setImage(.eyeOff, for: .normal)
        $0.tintColor = .modeBlack
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
    }
    private let errorLabel = PiCKLabel(
        textColor: .error,
        font: .pickFont(.caption2)
    )

    public init(
        titleText: String? = nil,
        placeholder: String? = nil,
        buttonIsHidden: Bool? = nil
    ) {
        super.init(frame: .zero)
        self.titleLabel.text = titleText
        self.placeholder = placeholder
        self.textHideButton.isHidden = buttonIsHidden ?? true

        setPlaceholder()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        setPlaceholder()
    }

    public override func attribute() {
        self.textColor = .modeBlack
        self.font = .pickFont(.caption1)
        self.backgroundColor = .gray50
        self.layer.cornerRadius = 4
        self.layer.border(color: borderColor, width: 1)
        self.addLeftView()
        self.addRightView()
        self.autocapitalizationType = .none
        self.autocorrectionType = .no
        self.keyboardType = .alphabet
    }
    public override func layout() {
        [
            titleLabel,
            textHideButton,
            errorLabel
        ].forEach { self.addSubview($0) }

        titleLabel.snp.makeConstraints {
            $0.bottom.equalTo(self.snp.top).offset(-12)
            $0.leading.equalToSuperview()
        }
        textHideButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
        }
        errorLabel.snp.makeConstraints {
            $0.top.equalTo(self.snp.bottom).offset(12)
            $0.trailing.equalToSuperview()
        }
    }

    private func setPlaceholder() {
        guard let string = self.placeholder else {
            return
        }
        attributedPlaceholder = NSAttributedString(
            string: string,
            attributes: [
                .foregroundColor: UIColor.gray500,
                .font: UIFont.pickFont(.caption2)
            ]
        )
    }

    public override func bindActions() {
        self.rx.controlEvent(.editingDidBegin)
            .bind { [weak self] _ in
                self?.layer.border(color: self?.borderColor, width: 1)
                self?.errorMessage.accept(nil)
            }.disposed(by: disposeBag)

        self.textHideButton.rx.tap
            .bind { [weak self] in
                self?.isSecureTextEntry.toggle()
                let imageName: UIImage = (self?.isSecureTextEntry ?? false) ? .eyeOff: .eyeOn
                self?.textHideButton.setImage(imageName, for: .normal)
            }.disposed(by: disposeBag)

        self.rx.controlEvent(.editingDidEnd)
            .bind { [weak self] in
                self?.layer.borderColor = UIColor.clear.cgColor
            }.disposed(by: disposeBag)

        errorMessage
            .bind { [weak self] content in
                self?.errorLabel.isHidden = content == nil
                guard let content = content else { return }
                self?.layer.borderColor = UIColor.error.cgColor
                self?.errorLabel.text = "\(content)"
            }.disposed(by: disposeBag)
    }

}
