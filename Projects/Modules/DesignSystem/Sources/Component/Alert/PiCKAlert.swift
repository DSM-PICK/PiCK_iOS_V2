import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core

public enum PiCKAlertType {
    case positive
    case negative
}

public class PiCKAlert: UIViewController {
    private let disposeBag = DisposeBag()

    public var actionOnTap: () -> Void

    private let backgroundView = UIView().then {
        $0.backgroundColor = .background
        $0.layer.cornerRadius = 8
    }
    private let titleLabel = PiCKLabel(
        textColor: .modeBlack,
        font: .pickFont(.subTitle2)
    )
    private let explainLabel = PiCKLabel(
        textColor: .gray700,
        font: .pickFont(.body1),
        numberOfLines: 0
    )
    private let cancelButton = UIButton(type: .system).then {
        $0.setTitle("취소", for: .normal)
        $0.setTitleColor(.gray600, for: .normal)
        $0.titleLabel?.font = .pickFont(.button1)
        $0.layer.cornerRadius = 4
        $0.backgroundColor = .gray50
    }
    private let confirmButton = UIButton(type: .system).then {
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(.modeWhite, for: .normal)
        $0.titleLabel?.font = .pickFont(.button1)
        $0.layer.cornerRadius = 4
        $0.backgroundColor = .main500
    }
    private lazy var buttonStackView = UIStackView(arrangedSubviews: [
        cancelButton,
        confirmButton
    ]).then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.distribution = .fillEqually
    }
    private lazy var backgroundStackView = UIStackView(arrangedSubviews: [
        titleLabel,
        explainLabel,
        buttonStackView
    ]).then {
        $0.axis = .vertical
        $0.spacing = 12
        $0.distribution = .equalSpacing
    }

    public init(
        titleText: String,
        explainText: String,
        type: PiCKAlertType,
        actionOnTap: @escaping () -> Void
    ) {
        self.titleLabel.text = titleText
        self.explainLabel.text = explainText
        if type == .positive {
            cancelButton.isHidden = true
        }
        self.actionOnTap = actionOnTap
        super.init(nibName: nil, bundle: nil)
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overFullScreen
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .placeholderText
        bindActions()
    }
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        addView()
        setLayout()
    }

    private func bindActions() {
        cancelButton.rx.tap
            .bind { [weak self] in
                self?.dismiss(animated: true)
            }.disposed(by: disposeBag)

        confirmButton.rx.tap
            .bind { [weak self] in
                self?.dismiss(animated: true) {
                    self?.actionOnTap()
                }
            }.disposed(by: disposeBag)
    }
    private func addView() {
        view.addSubview(backgroundView)
        backgroundView.addSubview(backgroundStackView)
    }
    private func setLayout() {
        backgroundView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(170)
        }
        backgroundStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
        }
    }

}
