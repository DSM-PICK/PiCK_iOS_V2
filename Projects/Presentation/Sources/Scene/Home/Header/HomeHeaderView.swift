import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import DesignSystem

public class HomeHeaderView: BaseView {
    private let titleLabel = PiCKLabel(
        textColor: .modeBlack,
        font: .pickFont(.label1)
    )
    private let explainLabel = PiCKLabel(
        textColor: .gray500,
        font: .pickFont(.body2)
    )

    public func setup(
        title: String,
        explain: String? = ""
    ) {
        self.titleLabel.text = title
        self.explainLabel.text = explain
    }

    public override func attribute() {
        self.backgroundColor = .gray50
        self.layer.cornerRadius = 8
    }

    public override func layout() {
        [
            titleLabel,
            explainLabel
        ].forEach { self.addSubview($0) }

        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(20)
        }
        explainLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
    }

}
