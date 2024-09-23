import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import DesignSystem

public class BugImageCollectionViewCell: BaseCollectionViewCell<Any> {
    static let identifier = "BugImageCollectionViewCell"

    public var deleteButtonTap: ControlEvent<Void> {
        return deleteButton.rx.tap
    }
    private let imageView = UIImageView().then {
        $0.layer.cornerRadius = 4
        $0.layer.masksToBounds = true
    }
    private let deleteButton = UIButton(type: .system).then {
        $0.setTitle("삭제", for: .normal)
        $0.setTitleColor(.error, for: .normal)
        $0.titleLabel?.font = .caption2
        $0.backgroundColor = .modeWhite
        $0.layer.cornerRadius = 8
    }

    public func setup(
        image: UIImage
    ) {
        self.imageView.image = image
    }

    public override func attribute() {
        self.layer.cornerRadius = 4
    }
    public override func layout() {
        [
            imageView,
            deleteButton
        ].forEach { self.addSubview($0) }

        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        deleteButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(8)
            $0.width.equalTo(29)
            $0.height.equalTo(18)
        }
    }

}
