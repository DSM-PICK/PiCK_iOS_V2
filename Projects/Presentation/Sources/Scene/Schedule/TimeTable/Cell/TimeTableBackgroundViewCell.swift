import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

import Core
import Domain
import DesignSystem

public class TimeTableBackgroundViewCell: BaseCollectionViewCell<TimeTableEntity> {
    static let identifier = "TimeTableBackgroundViewCell"

    private lazy var timeTableData = PublishRelay<[TimeTableEntityElement]>()

    private let dateLabel = PiCKLabel(textColor: .gray900, font: .label1)
    private let emptyTimeTableLabel = PiCKLabel(
        text: "시간표가 없습니다.",
        textColor: .gray800,
        font: .caption1
    )
    private lazy var collectionviewLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = 12
        $0.itemSize = .init(width: self.frame.width, height: 44)
    }
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionviewLayout
    ).then {
        $0.backgroundColor = .background
        $0.register(
            TimeTableCollectionViewCell.self,
            forCellWithReuseIdentifier: TimeTableCollectionViewCell.identifier
        )
    }

    public override func adapt(model: TimeTableEntity) {
        super.adapt(model: model)

        self.dateLabel.text = "\(model.date.toDate(type: .fullDate).toString(type: .dayKor))"
        self.timeTableData.accept(model.timetables)

        let timeTableIsEmpty = model.timetables.isEmpty
        self.emptyTimeTableLabel.isHidden = !timeTableIsEmpty
        self.collectionView.isHidden = timeTableIsEmpty
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
            dateLabel,
            emptyTimeTableLabel,
            collectionView
        ].forEach { self.addSubview($0) }

        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(24)
        }
        emptyTimeTableLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(15)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

}
