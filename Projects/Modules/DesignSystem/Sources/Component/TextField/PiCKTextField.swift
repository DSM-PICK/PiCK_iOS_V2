//import UIKit
//
//class PiCKTextField: BaseTextField {
//    
//    var borderColor: UIColor {
//        isEditing ? .main500 : .clear
//    }
//    
//    override func attribute() {
//        self.backgroundColor = .gray50
//        self.layer.cornerRadius = 8
//        self.layer.borderColor = borderColor.cgColor
//        self.layer.borderWidth = 1
//        
//        self.tintColor = .red
//    }
//}


import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

public class PiCKTextField: UITextField {
    
    private let disposeBag = DisposeBag()
    
    public var errorMessage = PublishRelay<String?>()
    
    public var isSecurity: Bool = false {
        didSet {
            textHideButton.isHidden = !isSecurity
            self.isSecureTextEntry = true
            self.addLeftAndRightView()
        }
    }
    
    private let titleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .label1
    }
    private let textHideButton = UIButton(type: .system).then {
        $0.setImage(.eyeOff, for: .normal)
        $0.tintColor = .black
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
    }
    private let errorLabel = UILabel().then {
        $0.textColor = .error
        $0.font = .caption2
    }
    
    public init(
        titleText: String,
        placeholder: String,
        isHidden: Bool
    ) {
        super.init(frame: .zero)
        self.titleLabel.text = titleText
        self.placeholder = placeholder
        self.textHideButton.isHidden = isHidden
        
        setup()
        bind()
        setPlaceholder()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        layout()
        setPlaceholder()
    }
    
    private func setup() {
        self.textColor = .black
        self.font = .caption1
        self.backgroundColor = .gray50
        self.layer.cornerRadius = 4
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 1
        self.tintColor = .purple
        self.addLeftView()
        self.addRightView()
        self.autocapitalizationType = .none
        self.autocorrectionType = .no
        self.keyboardType = .alphabet
    }
    
    private func layout() {
        [
            titleLabel,
            textHideButton,
            errorLabel
        ].forEach { self.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.bottom.equalTo(self.snp.top).offset(-12)
            $0.left.equalToSuperview()
        }
        textHideButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(16)
        }
        errorLabel.snp.makeConstraints {
            $0.top.equalTo(self.snp.bottom)
            $0.left.equalToSuperview()
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
                .font: UIFont.caption2
            ]
        )
    }
    
}

extension PiCKTextField {
    
    private func bind() {
        self.rx.text.orEmpty
            .map { $0.isEmpty ? UIColor.clear.cgColor : UIColor.main500.cgColor }
            .subscribe(
                onNext: { [weak self] borderColor in
                    self?.layer.borderColor = borderColor
                }
            )
            .disposed(by: disposeBag)
        
        self.textHideButton.rx.tap
            .subscribe(
                onNext: { [weak self] in
                    self?.isSecureTextEntry.toggle()
                    let imageName: UIImage = (self?.isSecureTextEntry ?? false) ? .eyeOff: .eyeOn
                    self?.textHideButton.setImage(imageName, for:.normal)
                }
            )
            .disposed(by: disposeBag)
        
        self.rx.controlEvent(.editingDidEnd)
            .subscribe(
                onNext: { [weak self] in
                    self?.layer.borderColor = UIColor.clear.cgColor
                }
            )
            .disposed(by: disposeBag)
        
        errorMessage
            .subscribe(
                onNext: { [weak self] content in
                    self?.errorLabel.isHidden = content == nil
                    guard let content = content else { return }
                    self?.layer.borderColor = UIColor.error.cgColor
                    self?.errorLabel.text = "\(content)"
                }
            )
            .disposed(by: disposeBag)
    }
    
}
