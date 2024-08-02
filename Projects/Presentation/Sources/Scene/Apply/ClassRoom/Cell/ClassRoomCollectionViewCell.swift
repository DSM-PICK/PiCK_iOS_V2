import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import DesignSystem

public class ClassRoomCollectionViewCell: BaseCollectionViewCell {
    static let identifier = "ClassRoomCollectionViewCell"

    private let classRoomLabel = PiCKLabel(textColor: .modeBlack, font: .body1)

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setup(
        classRoom: String
    ) {
        self.classRoomLabel.text = classRoom
    }

    public override func attribute() {
        super.attribute()

        self.backgroundColor = .background
        self.layer.border(color: .main100, width: 1)
        self.layer.cornerRadius = 10
    }

    public override func layout() {
        self.addSubview(classRoomLabel)

        classRoomLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

}
