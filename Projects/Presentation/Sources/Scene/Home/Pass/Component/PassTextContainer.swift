import UIKit

import SnapKit
import Then

import Core
import DesignSystem

public class PassTextContainer: BaseView {
    private let titleLabel = PiCKLabel(
        textColor: .gray700,
        font: .body2
    )
    private let contentLabel = PiCKLabel(
        textColor: .modeBlack,
        font: .subTitle3
    )

    public func setup(
        content: String
    ) {
        self.contentLabel.text = content
    }

    public init(
        title: String
    ) {
        self.titleLabel.text = title
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layout() {
        [
            titleLabel,
            contentLabel
        ].forEach { self.addSubview($0) }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview()
        }
    }

}
