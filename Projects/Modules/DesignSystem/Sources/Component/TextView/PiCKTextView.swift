import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core

public class PiCKTextView: BaseView {
    public var isEdit = BehaviorRelay<Bool>(value: false)

    private let titleLabel = PiCKLabel(
        textColor: .modeBlack,
        font: .label1
    )
    private let textView = UITextView().then {
        $0.textColor = .modeBlack
        $0.font = .caption2
        $0.textContainer.maximumNumberOfLines = 8
        $0.backgroundColor = .gray50
        $0.layer.cornerRadius = 4
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .none
        $0.textContainerInset = UIEdgeInsets(top: 14, left: 16, bottom: 16, right: 16)
    }
    private let placeholderLabel = PiCKLabel(
        textColor: .gray500,
        font: .caption2
    )

    public init(
        title: String,
        placeholder: String
    ) {
        self.titleLabel.text = title
        self.placeholderLabel.text = placeholder
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layout() {
        [
            titleLabel,
            textView
        ].forEach { self.addSubview($0) }
        self.textView.addSubview(placeholderLabel)

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        textView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        placeholderLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.left.equalToSuperview().inset(16)
        }
    }

    public override func bind() {
        self.textView.rx.didBeginEditing
            .bind(onNext: { [weak self] in
                self?.placeholderLabel.isHidden = true
                self?.isEdit.accept(true)
            }).disposed(by: disposeBag)
        
        self.textView.rx.didEndEditing
            .bind(onNext: { [weak self] in
                if self?.textView.text.isEmpty == true {
                    self?.placeholderLabel.isHidden = false
                    self?.isEdit.accept(false)
                }
            }).disposed(by: disposeBag)
    }

}

