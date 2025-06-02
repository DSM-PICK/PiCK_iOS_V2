import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import DesignSystem

class ClassroomBackgroundCell: BaseCollectionViewCell<Any> {
    static let identifier = "ClassroomBackgroundCell"

    public var didSelectClassroom: ((String) -> Void)?

    private let classroomData = ClassroomData.shared

    private let classroomMoveApplyRelay = PublishRelay<Void>()
    private var classroomText = BehaviorRelay<String>(value: "")
    private var startPeriod = BehaviorRelay<Int>(value: 1)
    private var endPeriod = BehaviorRelay<Int>(value: 1)
    private lazy var selectedSegemetedControlIndex = BehaviorRelay<Int>(value: 1)
    private lazy var currentFloorClassroomArray = BehaviorRelay<[String]>(value: classroomData.firstFloor)

    private lazy var collectionViewFlowLayout = LeftAlignedCollectionViewFlowLayout().then {
        $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        $0.minimumLineSpacing = 15
        $0.minimumInteritemSpacing = 16
    }
    private lazy var classroomCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewFlowLayout
    ).then {
        $0.backgroundColor = .background
        $0.register(
            ClassroomCollectionViewCell.self,
            forCellWithReuseIdentifier: ClassroomCollectionViewCell.identifier
        )
        $0.contentInsetAdjustmentBehavior = .always
        $0.bounces = false
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setup(data: [String]) {
        self.currentFloorClassroomArray.accept(data)
    }
    public override func attribute() {
        super.attribute()

        self.backgroundColor = .background
    }
    override func bind() {
        currentFloorClassroomArray
            .bind(to: classroomCollectionView.rx.items(
                cellIdentifier: ClassroomCollectionViewCell.identifier,
                cellType: ClassroomCollectionViewCell.self
            )) { _, item, cell in
                cell.setup(classroom: item)
            }.disposed(by: disposeBag)

        classroomCollectionView.rx.itemSelected
            .withUnretained(self)
            .bind { owner, index in
                owner.didSelectClassroom?(owner.currentFloorClassroomArray.value[index.row])
            }.disposed(by: disposeBag)
    }
    public override func layout() {
        self.addSubview(classroomCollectionView)

        classroomCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

}
