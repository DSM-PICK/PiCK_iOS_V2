import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import Domain
import DesignSystem

public class NoticeCollectionViewCell: BaseCollectionViewCell<NoticeListEntityElement> {
    static let identifier = "NoticeCollectionViewCell"

    private var id: UUID = UUID()

    private let noticeImageView = UIImageView(image: .notice).then {
        $0.tintColor = .main300
    }
    private let titleLabel = PiCKLabel(
        textColor: .modeBlack,
        font: .label1
    )
    private let daysAgoLabel = PiCKLabel(
        textColor: .gray600,
        font: .body2
    )
    private lazy var titleStackView = UIStackView(arrangedSubviews: [
        titleLabel,
        daysAgoLabel
    ]).then {
        $0.axis = .vertical
        $0.spacing = 8
    }
    private let newNoticeIcon = UIImageView(image: .newNotice).then {
        $0.tintColor = .main400
        $0.isHidden = true
    }

    public override func adapt(model: NoticeListEntityElement) {
        super.adapt(model: model)

        self.id = model.id
        self.titleLabel.text = model.title
        self.daysAgoLabel.text = model.createAt
        if model.createAt == Date().toString(type: .fullDate) {
            self.newNoticeIcon.isHidden = false
        }
    }

    public override func layout() {
        [
            noticeImageView,
            titleStackView,
            newNoticeIcon
        ].forEach { self.addSubview($0) }

        noticeImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(24)
        }
        titleStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(noticeImageView.snp.trailing).offset(24)
        }
        newNoticeIcon.snp.makeConstraints {
            $0.top.equalTo(titleStackView.snp.top).offset(2.5)
            $0.leading.equalTo(titleStackView.snp.trailing).offset(4)
        }
    }

}
