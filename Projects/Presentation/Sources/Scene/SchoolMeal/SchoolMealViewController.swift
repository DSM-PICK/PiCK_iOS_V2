import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import DesignSystem

public class SchoolMealViewController: BaseViewController<SchoolMealViewModel> {
    private lazy var navigationBar = PiCKMainNavigationBar(view: self)
    private lazy var schoolMealCalendarView = PiCKCalendar(selectedDate: Date(), type: .week, presentViewController: self)
    private let dateLabel = PiCKLabel(
        text: "오늘 4월 13일",
        textColor: .modeBlack,
        font: .heading4
    ).then {
        $0.changePointColor(targetString: "오늘", color: .main500)
    }
    private lazy var collectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.itemSize = .init(width: self.view.frame.width - 48, height: 154)
        $0.minimumLineSpacing = 20
    }
    private lazy var schoolMealCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewFlowLayout
    ).then {
        $0.backgroundColor = .background
        $0.showsVerticalScrollIndicator = false
        $0.register(
            SchoolMealCollectionViewCell.self,
            forCellWithReuseIdentifier: SchoolMealCollectionViewCell.identifier
        )
        $0.delegate = self
        $0.dataSource = self
    }

    public override func configureNavgationBarLayOutSubviews() {
        super.configureNavgationBarLayOutSubviews()

        navigationController?.isNavigationBarHidden = true
    }
    public override func addView() {
        [
            navigationBar,
            schoolMealCalendarView,
            dateLabel,
            schoolMealCollectionView
        ].forEach { view.addSubview($0) }
    }
    public override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        schoolMealCalendarView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(150)
        }
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(schoolMealCalendarView.snp.bottom).offset(36)
            $0.leading.equalToSuperview().inset(24)
        }
        schoolMealCollectionView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(36)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview()
        }
    }

}

extension SchoolMealViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SchoolMealCollectionViewCell.identifier, for: indexPath) as? SchoolMealCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.setup(mealTime: "조식", menu: "ㄹ너ㅣㅏ\nㅓㄹㅇ날ㄴ\nㄹ어나ㅣ")
        return cell
    }


}
