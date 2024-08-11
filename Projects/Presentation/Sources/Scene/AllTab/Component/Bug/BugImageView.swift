import UIKit

import SnapKit
import Then

import Core
import DesignSystem

public class BugImageView: BaseView {
    private let imageView = UIImageView(image: .imageIcon).then {
        $0.tintColor = .gray500
    }
    private let explainLabel = PiCKLabel(text: "사진을 첨부해주세요.", textColor: .gray500, font: .caption2)

    public override func attribute() {
        super.attribute()

        self.layer.cornerRadius = 4
        self.backgroundColor = .gray50
    }
    public override func layout() {
        [
            imageView,
            explainLabel
        ].forEach { self.addSubview($0) }

        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(24)
        }
        explainLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(24)
        }

        setDashedLine()
    }

    private func setDashedLine() {
        self.layer.addDotBorder(color: .gray600, lineWidth: 1, dotRadius: 3)
    }

}
