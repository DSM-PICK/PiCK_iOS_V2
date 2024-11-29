import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa
import RxDataSources

import Core
import Domain
import DesignSystem

public class HomeTimeTableView: BaseView {
    private let timeTableData = BehaviorRelay<[TimeTableEntityElement]>(value: [])

    private let backgroundView = UIView().then {
        $0.backgroundColor = .gray50
        $0.layer.cornerRadius = 8
    }
    private let emptyTimeTableLabel = PiCKLabel(
        text: "오늘은 등록된 시간표가 없습니다",
        textColor: .modeBlack,
        font: .pickFont(.body1),
        isHidden: true
    )

    private lazy var collectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.itemSize = .init(width: self.frame.width, height: 44)
        $0.minimumLineSpacing = 4
    }
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewFlowLayout
    ).then {
        $0.backgroundColor = .background
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.register(
            TimeTableCollectionViewCell.self,
            forCellWithReuseIdentifier: TimeTableCollectionViewCell.identifier
        )
        $0.bounces = false
    }

    public func setup(
        timeTableData: [TimeTableEntityElement]
    ) {
        let timeTableIsEmpty = timeTableData.isEmpty

        self.emptyTimeTableLabel.isHidden = !timeTableIsEmpty
        self.collectionView.isHidden = timeTableIsEmpty

        self.timeTableData.accept(timeTableData)
    }

    public override func bind() {
        timeTableData.asObservable()
            .bind(to: collectionView.rx.items(
                cellIdentifier: TimeTableCollectionViewCell.identifier,
                cellType: TimeTableCollectionViewCell.self
            )) { _, item, cell in
                cell.adapt(model: item)
            }.disposed(by: disposeBag)
    }
    public override func layout() {
        [
            backgroundView,
            collectionView
        ].forEach { self.addSubview($0) }

        backgroundView.addSubview(emptyTimeTableLabel)

        backgroundView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(59)
        }
        emptyTimeTableLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

}
