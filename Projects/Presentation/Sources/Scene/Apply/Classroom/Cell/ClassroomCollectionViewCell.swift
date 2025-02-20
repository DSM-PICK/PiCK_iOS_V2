import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import DesignSystem

public class ClassroomCollectionViewCell: BaseCollectionViewCell<Any> {
    static let identifier = "ClassroomCollectionViewCell"

    public override var isSelected: Bool {
        didSet {
            self.attribute()
        }
    }

    private var bgColor: UIColor {
        isSelected ? .main100 : .background
    }

    private let classroomLabel = PiCKLabel(
        textColor: .modeBlack,
        font: .pickFont(.body1),
        numberOfLines: 1
    )

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setup(
        classroom: String
    ) {
        self.classroomLabel.text = classroom
        self.layout()
    }

    public override func attribute() {
        super.attribute()

        self.backgroundColor = bgColor
        self.layer.border(color: .main100, width: 1)
        self.layer.cornerRadius = 16
        self.classroomLabel.textColor = .modeBlack
    }
    public override func layout() {
        self.addSubview(classroomLabel)

        classroomLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.bottom.equalToSuperview().inset(8)
        }
    }

}
