import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import DesignSystem

public class SchoolMealViewController: BaseViewController<SchoolMealViewModel> {
    private let todayDate = Date()
    private let loadSchoolMealRelay = PublishRelay<String>()

    private lazy var navigationBar = PiCKMainNavigationBar(view: self)
    private lazy var schoolMealCalendarView = PiCKCalendarView(
        calnedarType: .schoolMealWeek,
        clickDate: { date in
            self.loadSchoolMeal(date: date)
        }
    )
    private lazy var dateLabel = PiCKLabel(
        text: "오늘 \(todayDate.toString(type: .monthAndDayKor))",
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
    }

    public override func configureNavgationBarLayOutSubviews() {
        super.configureNavgationBarLayOutSubviews()

        navigationController?.isNavigationBarHidden = true
    }
    public override func bindAction() {
        loadSchoolMealRelay.accept(todayDate.toString(type: .fullDate))
    }
    public override func bind() {
        let input = SchoolMealViewModel.Input(
            schoolMealDate: loadSchoolMealRelay.asObservable()
        )
        let output = viewModel.transform(input: input)

        output.schoolMealData.asObservable()
            .bind(to: schoolMealCollectionView.rx.items(
                cellIdentifier: SchoolMealCollectionViewCell.identifier,
                cellType: SchoolMealCollectionViewCell.self
            )) { row, item, cell in
                cell.setup(
                    mealTime: item.1,
                    menu: item.2.menu,
                    kcal: item.2.kcal
                )
            }.disposed(by: disposeBag)

        schoolMealCalendarView.clickBottomToggleButton
            .bind(onNext: { [weak self] in
                let alert = PiCKCalendarAlert(
                    calendarType: .schoolMealMonth,
                    clickDate: { date in
                        self?.loadSchoolMeal(date: date)
                    }
                )
                alert.modalTransitionStyle = .crossDissolve
                alert.modalPresentationStyle = .overFullScreen
                self?.present(alert, animated: true)
            }).disposed(by: disposeBag)
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
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(300)
        }
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(160)
            $0.leading.equalToSuperview().inset(24)
        }
        schoolMealCollectionView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(26)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview()
        }
    }

    private func loadSchoolMeal(date: Date) {
        self.schoolMealCalendarView.setupDate(date: date)
        self.loadSchoolMealRelay.accept(date.toString(type: .fullDate))

        if date.toString(type: .fullDate) == self.todayDate.toString(type: .fullDate) {
            self.dateLabel.text = "오늘 \(date.toString(type: .monthAndDayKor))"
            self.dateLabel.changePointColor(targetString: "오늘", color: .main500)
        } else {
            self.dateLabel.text = "\(date.toString(type: .monthAndDayKor))"
        }
    }

}
