import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import DesignSystem

public class ClassRoomMoveViewController: BaseViewController<ClassRoomMoveViewModel> {

    private let titleLabel = PiCKLabel(text: "교실 이동", textColor: .modeBlack, font: .heading4)
    private let explainLabel = PiCKLabel(text: "자습 감독 선생님께서 수락 후 이동할 수 있습니다.", textColor: .gray600, font: .body2)
    private let segmetedControl = ClassRoomSegmentedControl(items: [
        "1층",
        "2층",
        "3층",
        "4층",
        "5층"
    ]).then {
        $0.selectedSegmentIndex = 0
    }
    private lazy var collectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.minimumLineSpacing = 16
        $0.minimumInteritemSpacing = 15
        $0.itemSize = .init(width: 64, height: 33)
    }
    private lazy var classRoomCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewFlowLayout
    ).then {
        $0.backgroundColor = .white
        $0.register(
            ClassRoomCollectionViewCell.self,
            forCellWithReuseIdentifier: ClassRoomCollectionViewCell.identifier
        )
        $0.contentInsetAdjustmentBehavior = .always
        $0.bounces = false
        $0.delegate = self
        $0.dataSource = self
    }
//    private lazy var classRoomCollectionView: UICollectionView = {
//            let layout = LeftAlignedCollectionViewFlowLayout().then {
//                $0.minimumLineSpacing = 16
//                $0.minimumInteritemSpacing = 15
////                $0.sectionInset = .init(top: 0, left: 20, bottom: 0, right: 20)
//                $0.itemSize = .init(width: 64, height: 33)
//                $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//            }
//            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//            collectionView.backgroundColor = .white
//            collectionView.register(
//                ClassRoomCollectionViewCell.self,
//                forCellWithReuseIdentifier: ClassRoomCollectionViewCell.identifier
//            )
//            collectionView.contentInsetAdjustmentBehavior = .always
//            collectionView.bounces = false
//            collectionView.delegate = self
//            collectionView.dataSource = self
//            return collectionView
//        }()
    private let nextButton = PiCKButton(type: .system, buttonText: "다음", isEnabled: false)

    public override func attribute() {
        super.attribute()

        navigationTitleText = "교실 이동 신청"
    }

    public override func addView() {
        [
            titleLabel,
            explainLabel,
            segmetedControl,
            classRoomCollectionView,
            nextButton
        ].forEach { view.addSubview($0) }
    }
    public override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            $0.leading.equalToSuperview().inset(24)
        }
        explainLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(24)
        }
        segmetedControl.snp.makeConstraints {
            $0.top.equalTo(explainLabel.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(25)
        }
        classRoomCollectionView.snp.makeConstraints {
            $0.top.equalTo(segmetedControl.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview()
        }
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(60)
        }
    }

    let textArray = [
        "3-1", "3-2", "3-3", "3-4",
        "세미나실 2-1", "세미나실 2-2",
        "세미나실 2-3", "SW 1실", "SW 2실",
        "SW 3실","본부 교무실", "제 3 교무실",
        "카페테리아", "창조실", "방송실",
        "진로 상담실", "여자 헬스장"
    ]

}

extension ClassRoomMoveViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return textArray.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClassRoomCollectionViewCell.identifier, for: indexPath) as? ClassRoomCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.setup(classRoom: textArray[indexPath.row])
        return cell
    }

}

//class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
//    override func layoutAttributesForElements(in rect: CGRect) ->  [UICollectionViewLayoutAttributes]? {
//        let attributes = super.layoutAttributesForElements(in: rect)?.map { $0.copy() as! UICollectionViewLayoutAttributes }
//        var leftMargin: CGFloat = 15.0
//        var maxY: CGFloat = -1.0
//    
//        attributes?.forEach { layoutAttribute in
//            guard layoutAttribute.representedElementCategory == .cell else {
//                return
//            }
//
//            if layoutAttribute.frame.origin.y >= maxY {
//                leftMargin = 15.0
//            }
//            layoutAttribute.frame.origin.x = leftMargin
//            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
//            maxY = max(layoutAttribute.frame.maxY , maxY)
//        }
//
//        return attributes
//    }
//
//}
