import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import Domain
import DesignSystem

public class HomeSchoolMealView: BaseView {
    private let schoolMealData = BehaviorRelay<[(String, MealEntityElement)]>(value: [])

    private lazy var collectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.itemSize = .init(width: self.frame.width, height: 134)
        $0.minimumLineSpacing = 0
    }
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewFlowLayout
    ).then {
        $0.backgroundColor = .background
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
            $0.register(
                SchoolMealHomeCell.self,
                forCellWithReuseIdentifier: SchoolMealHomeCell.identifier
            )
        $0.bounces = false
    }

    public func setup(
        schoolMealData: [(String, MealEntityElement)]
    ) {
        self.schoolMealData.accept(schoolMealData)
    }

    public override func bind() {
        schoolMealData.asObservable()
            .bind(to: collectionView.rx.items(
                cellIdentifier: SchoolMealHomeCell.identifier,
                cellType: SchoolMealHomeCell.self
            )) { _, item, cell in
                cell.setup(
                    mealTime: item.0,
                    menu: item.1.menu,
                    kcal: item.1.kcal
                )
            }.disposed(by: disposeBag)
    }

    public override func layout() {
        self.addSubview(collectionView)

        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

}
