import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core

public class PiCKTextView: BaseTextView {
    
    private let placeholderLabel = UILabel().then {
        $0.text = "내용을 입력해주세요"
        $0.textColor = .gray500
        $0.font = .caption2
        $0.isHidden = false
    }

    public init(
        placeholder: String
    ) {
        self.placeholderLabel.text = placeholder
        super.init(frame: .zero, textContainer: .none)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func attribute() {
        self.textColor = .modeBlack
        self.font = .caption2
        self.textContainer.maximumNumberOfLines = 0
        self.backgroundColor = .gray50
        self.layer.cornerRadius = 4
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        self.textContainerInset = UIEdgeInsets(top: 14, left: 16, bottom: 16, right: 16)
    }
    public override func layout() {
        self.addSubview(placeholderLabel)
        
        placeholderLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.left.equalToSuperview().inset(16)
        }
    }

    public override func bindActions() {
        self.rx.didBeginEditing
            .bind(onNext: { [weak self] in
                self?.placeholderLabel.isHidden = true
            }).disposed(by: disposeBag)
        
        self.rx.didEndEditing
            .bind(onNext: { [weak self] in
                if self?.text.isEmpty == true {
                    self?.placeholderLabel.isHidden = false
                }
            }).disposed(by: disposeBag)
    }

}

