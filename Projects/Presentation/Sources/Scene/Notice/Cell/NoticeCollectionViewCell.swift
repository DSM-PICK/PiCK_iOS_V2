import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import DesignSystem

class NoticeCollectionViewCell: BaseCollectionViewCell {
    
    static let identifier = "NoticeCollectionViewCell"
    
    private let noticeImageView = UIImageView(image: .notice)
    private let titleLabel = UILabel().then {
        $0.textColor = .modeBlack
        $0.font = .label1
    }
    private let daysAgoLabel = UILabel().then {
        $0.textColor = .gray600
        $0.font = .body2
    }
    private lazy var titleStackView = UIStackView(arrangedSubviews: [
        titleLabel,
        daysAgoLabel
    ]).then {
        $0.axis = .vertical
        $0.spacing = 8
    }
    private let newNoticeIcon = UIImageView(image: .newNotice).then {
        $0.isHidden = true
    }
    
    public func setup(
        title: String,
        daysAgo: String,
        isNew: Bool
    ) {
        self.titleLabel.text = title
        self.daysAgoLabel.text = daysAgo
        self.newNoticeIcon.isHidden = isNew
    }
    
    override func layout() {
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
