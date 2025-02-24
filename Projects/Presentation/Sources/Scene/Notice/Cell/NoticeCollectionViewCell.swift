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
        font: .pickFont(.label1)
    )
    private let daysAgoLabel = PiCKLabel(
        textColor: .gray600,
        font: .pickFont(.body2)
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

    /// Updates the cell's UI components using details from the provided notice model.
    ///
    /// Assigns the unique identifier and title from the model, calculates the number of days since
    /// the notice's creation, and updates the daysAgo label accordingly. If the notice was created
    /// today, the label displays "오늘" and the new notice icon is revealed.
    ///
    /// - Parameter model: The notice model containing the data used to populate the cell.
    public override func adapt(model: NoticeListEntityElement) {
        super.adapt(model: model)

        self.id = model.id
        self.titleLabel.text = model.title

        let dateGap = Calendar.current.getDateGap(from: model.createAt.toDate(type: .fullDate))
        self.daysAgoLabel.text = "\(dateGap == 0 ? "오늘" : "\(dateGap)일 전")"

        if model.createAt == Date().toString(type: .fullDate) {
            self.newNoticeIcon.isHidden = false
        }
    }

    /// Configures the layout of the cell's subviews.
    ///
    /// This method adds the notice image view, title stack view, and new notice icon as subviews, then defines their constraints using SnapKit. The notice image view is centered vertically and inset 24 points from the left. The title stack view is centered vertically and positioned 24 points to the right of the notice image view. The new notice icon is aligned with the top of the title stack view with a 2-point vertical offset and placed 4 points to its right.
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
            $0.top.equalTo(titleStackView.snp.top).offset(2)
            $0.leading.equalTo(titleStackView.snp.trailing).offset(4)
        }
    }

}
