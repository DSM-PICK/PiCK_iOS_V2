import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa
import RxGesture

import Core

public class PiCKApplyView: BaseView {
    
//    private var isClick: Bool = false {
//        didSet {
//            self.attribute()
//        }
//    }
    public var isClick: Bool = false
    
    private var borderColor: UIColor {
        isClick ? .gray50 : .main500
    }
    
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel().then {
        $0.textColor = .modeBlack
        $0.font = .label1
    }
    private let explainLabel = UILabel().then {
        $0.textColor = .gray800
        $0.font = .label2
        $0.numberOfLines = 0
    }.then {
        $0.isHidden = true
    }
    private let applyButton = PiCKButton(type: .system, buttonText: "신청하기").then {
        $0.isHidden = true
    }
    
    public init(
        icon: UIImage? = nil,
        title: String? = nil,
        explain: String? = nil
    ) {
        super.init(frame: .zero)
        self.iconImageView.image = icon
        self.titleLabel.text = title
        self.explainLabel.text = explain
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func attribute() {
        self.backgroundColor = .background
        self.layer.cornerRadius = 8
        self.layer.border(color: borderColor, width: 1)
        
        self.rx.tapGesture()
            .when(.recognized)
            .bind(onNext: { [weak self] _ in
                self?.toggleHeight()
            }).disposed(by: disposeBag)
    }
    private func toggleHeight() {
        let newHeight: CGFloat = isClick ? 60 : 156
           
        self.snp.remakeConstraints {
            $0.height.equalTo(newHeight)
        }
        self.applyButton.isHidden = isClick
        self.explainLabel.isHidden = isClick
        UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve) {
//            self.setNeedsLayout()
//            self.layoutIfNeeded()
//            self.reloadInputViews()
        }
        
        self.isClick.toggle()
    }
    public override func layout() {
        [
            iconImageView,
            titleLabel,
            explainLabel,
            applyButton
        ].forEach { self.addSubview($0) }

        self.snp.makeConstraints {
            $0.height.equalTo(60)
        }
        iconImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(16)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalTo(iconImageView.snp.trailing).offset(12)
        }
        explainLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(16)
        }
        applyButton.snp.makeConstraints {
            $0.top.equalTo(explainLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

    }

}
