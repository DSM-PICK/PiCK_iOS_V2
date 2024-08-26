import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa
import RxDataSources

import Core
import Domain
import DesignSystem

struct ddd {
    var text = "fdjsklfjdslk"
}
struct TimeTableHeadrElement {
  var header: String
  var items: [Item]
}

extension TimeTableHeadrElement: SectionModelType {
  typealias Item = ddd
  
  init(original: TimeTableHeadrElement, items: [ddd]) {
    self = original
    self.items = items
  }
}

public class HomeTimeTableView: BaseView {
    private let timeTableData = BehaviorRelay<[TimeTableEntityElement]>(value: [])

    private var emptyTimeTableLabel = PiCKLabel(
        text: "오늘은 등록된 시간표가 없습니다",
        textColor: .modeBlack,
        font: .body1,
        isHidden: true
    )
    private lazy var datasource = RxCollectionViewSectionedReloadDataSource<TimeTableHeadrElement>(
        configureCell: { dataSource, collectionView, indexPath, boardPost in
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TimeTableCollectionViewCell.identifier,
                for: indexPath
                ) as? TimeTableCollectionViewCell
//                  cell?.configureCell(with: boardPost)
            return cell ?? UICollectionViewCell()
        }, configureSupplementaryView: { dataSource, collectionview, title, indexPath in
            let header = collectionview.dequeueReusableSupplementaryView(
              ofKind: UICollectionView.elementKindSectionHeader,
              withReuseIdentifier: HomeHeaderView.identifier,
              for: indexPath
            ) as? HomeHeaderView
            return header ?? UICollectionReusableView()
        }
    )
    private lazy var headerView = HomeHeaderView()
    private lazy var collectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.itemSize = .init(width: self.frame.width, height: 44)
        $0.minimumLineSpacing = 4
    }
    //TODO: 시간표가 바뀌었다는 알림을 headerView로 표현?
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
        $0.register(
            HomeHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HomeHeaderView.identifier
        )
        $0.bounces = false
    }

    public func setup(
        timeTableData: [TimeTableEntityElement]
    ) {
        self.timeTableData.accept(timeTableData)
    }

    var sections = [
        TimeTableHeadrElement(
            header: "fjdslk",
            items: [ddd()]
        )
      ]
    public override func bind() {
        timeTableData.asObservable()
            .bind(to: collectionView.rx.items(
                cellIdentifier: TimeTableCollectionViewCell.identifier,
                cellType: TimeTableCollectionViewCell.self
            )) { row, item, cell in
                if item.subjectName.isEmpty == true {
                    self.collectionView.isHidden = true
                    self.emptyTimeTableLabel.isHidden = false
                }
                cell.adapt(model: item)
            }.disposed(by: disposeBag)
//        Observable.just(sections)
//            .bind(to: collectionView.rx.items(dataSource: datasource))
//            .disposed(by: disposeBag)
    }
    public override func layout() {
        [
            emptyTimeTableLabel,
            collectionView
        ].forEach { self.addSubview($0) }

        emptyTimeTableLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

}

