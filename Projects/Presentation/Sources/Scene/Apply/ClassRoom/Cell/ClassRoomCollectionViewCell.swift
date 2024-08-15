import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import DesignSystem

public class ClassRoomCollectionViewCell: BaseCollectionViewCell<Any> {
    static let identifier = "ClassRoomCollectionViewCell"

    public override var isSelected: Bool {
        didSet {
            self.attribute()
        }
    }

    private var bgColor: UIColor {
        isSelected ? .main100 : .background
    }

    private let classRoomLabel = PiCKLabel(textColor: .modeBlack, font: .body1, numberOfLines: 1)

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//    public override func adapt(model: ClassRoomModel) {
//        super.adapt(model: model)
//
//        self.classRoomLabel.text = model.classRoom
//        self.layout()
//    }
    public func setup(
        classRoom: String
    ) {
        self.classRoomLabel.text = classRoom
        self.layout()
    }

    public override func attribute() {
        super.attribute()

        self.backgroundColor = bgColor
        self.layer.border(color: .main100, width: 1)
        self.layer.cornerRadius = 16
        self.classRoomLabel.textColor = .modeBlack
    }
    public override func layout() {
        self.addSubview(classRoomLabel)

        classRoomLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.bottom.equalToSuperview().inset(8)
        }
    }

}
