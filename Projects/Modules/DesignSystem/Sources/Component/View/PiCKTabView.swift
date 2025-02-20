import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa
import RxGesture

import Core

public class PiCKTabView: BaseView {
    public var clickActionButton: ControlEvent<Void> {
        return actionButton.buttonTap
    }

    public var isOpen = false {
        didSet {
            UIView.animate(
                withDuration: 0.35,
                delay: 0,
                usingSpringWithDamping: 0.9,
                initialSpringVelocity: 1,
                options: .transitionCrossDissolve
            ) { [self] in
                detailStackView.arrangedSubviews.forEach {
                    $0.isHidden = !isOpen
                }
                detailStackView.arrangedSubviews.forEach {
                    $0.alpha = isOpen ? 1 : 0
                }
                backgroundView.layer.border(color: borderColor, width: 1)
                self.layoutIfNeeded()
            }
        }
    }
    private var borderColor: UIColor {
        isOpen ? .main500 : .gray50
    }

    private lazy var backgroundView = UIView().then {
        $0.backgroundColor = .background
        $0.layer.border(color: borderColor, width: 1)
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }

    private let iconImageView = UIImageView().then {
        $0.tintColor = .gray800
    }
    private let titleLabel = PiCKLabel(
        textColor: .modeBlack,
        font: .pickFont(.label1)
    )
    private lazy var titleStackView = UIStackView(arrangedSubviews: [
        iconImageView,
        titleLabel
    ]).then {
        $0.axis = .horizontal
        $0.spacing = 12
    }

    private let explainLabel = PiCKLabel(
        textColor: .gray800,
        font: .pickFont(.label2),
        isHidden: true
    )
    private lazy var actionButton = PiCKButton(
        buttonText: "신청하기",
        isHidden: true,
        height: 36
    )
    private lazy var detailStackView = UIStackView(arrangedSubviews: [
        explainLabel,
        actionButton
    ]).then {
        $0.axis = .vertical
        $0.spacing = 16
        $0.layoutMargins = .init(
            top: 16,
            left: 0,
            bottom: 0,
            right: 0
        )
        $0.isLayoutMarginsRelativeArrangement = true
    }

    public func setup(
        explain: String,
        buttonText: String
    ) {
        self.explainLabel.text = explain
        self.actionButton.setTitle(buttonText, for: .normal)
    }

    public init(
        title: String,
        explain: String,
        icon: UIImage
    ) {
        self.titleLabel.text = title
        self.explainLabel.text = explain
        self.iconImageView.image = icon
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func bind() {
        self.rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .bind { owner, _ in
                owner.isOpen.toggle()
            }.disposed(by: disposeBag)
    }
    public override func layout() {
        self.addSubview(backgroundView)

        [
            titleStackView,
            detailStackView
        ].forEach { backgroundView.addSubview($0) }

        titleStackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(16)
        }
        detailStackView.snp.updateConstraints {
            $0.top.equalTo(titleStackView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(isOpen ? 16 : 0)
        }
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

}
