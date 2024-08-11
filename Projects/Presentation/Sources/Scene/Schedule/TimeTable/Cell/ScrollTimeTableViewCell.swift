import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

import Core
import Domain
import DesignSystem

public class TimeTableBackgroundViewCell: BaseCollectionViewCell {
    static let identifier = "scrollTimeTableViewCellID"

//    private lazy var timeTableData = PublishRelay<[TimeTableEntityElement]>()

    private let dateLabel = PiCKLabel(text: "fjdsl", textColor: .gray900, font: .label1)
    private lazy var collectionviewLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = 12
        $0.itemSize = .init(width: self.frame.width, height: 44)
    }
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionviewLayout
    ).then {
        $0.backgroundColor = .white
        $0.register(
            TimeTableCollectionViewCell.self,
            forCellWithReuseIdentifier: TimeTableCollectionViewCell.identifier
        )
        $0.delegate = self
        $0.dataSource = self
    }
    
//    public func setup(
//        date: String,
//        timeTableData: [TimeTableEntityElement]
//    ) {
//        self.dateLabel.text = date
//        self.timeTableData.accept(timeTableData)
//    }

//    public override func bind() {
//        timeTableData.asObservable()
//            .bind(to: collectionView.rx.items(
//                cellIdentifier: TimeTableCollectionViewCell.identifier,
//                cellType: TimeTableCollectionViewCell.self
//            )) { row, element, cell in
//                cell.setup(
//                    period: "1",
//                    image: .PiCKLogo,
//                    subject: "창체"
//                )
//            }
//            .disposed(by: disposeBag)
//    }
    public override func layout() {
        [
            dateLabel,
            collectionView
        ].forEach { self.addSubview($0) }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(28)
            $0.leading.equalToSuperview()
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(7)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()//.inset(100)
        }
    }

}

extension TimeTableBackgroundViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimeTableCollectionViewCell.identifier, for: indexPath) as? TimeTableCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.setup(period: 1, image: .alert, subject: "fjdskl")
        return cell
    }

}
