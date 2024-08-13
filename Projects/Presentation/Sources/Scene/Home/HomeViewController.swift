import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import DesignSystem

public class HomeViewController: BaseViewController<HomeViewModel> {
    private let viewModeRelay = PublishRelay<HomeViewType>()

    private lazy var homeViewType: HomeViewType = .timeTable
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
    }
    private let contentView = UIView()
    private let mainView = UIView()

    private lazy var navigationBar = PiCKMainNavigationBar(view: self, settingIsHidden: false)
    private let profileView = PiCKProfileView()

    private let todayTimeTableLabel = PiCKLabel(
        text: "오늘의 시간표",
        textColor: .gray700,
        font: .label1
    )
    private lazy var topCollectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        switch homeViewType {
        case .timeTable:
            $0.itemSize = .init(width: self.view.frame.width, height: 44)
        case .schoolMeal:
            $0.itemSize = .init(width: self.view.frame.width, height: 102)
        }
    }
    //TODO: 시간표가 바뀌었다는 알림을 headerView로 표현?
    private lazy var topCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: topCollectionViewFlowLayout
    ).then {
        $0.backgroundColor = .background
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
//        switch viewModeType {
//        case .timeTable:
            $0.register(
                TimeTableCollectionViewCell.self,
                forCellWithReuseIdentifier: TimeTableCollectionViewCell.identifier
            )
//        case .schoolMeal:
            $0.register(
                SchoolMealHomeCell.self,
                forCellWithReuseIdentifier: SchoolMealHomeCell.identifier
            )
//        }
        $0.delegate = self
        $0.dataSource = self
    }
    private let selfStudyBannerView = PiCKMainBannerView()
    private let recentNoticeLabel = PiCKLabel(
        text: "최신 공지",
        textColor: .gray700,
        font: .label1
    )
    private let viewMoreButton = UIButton(type: .system).then {
        $0.setTitle("더보기", for: .normal)
        $0.setTitleColor(.gray800, for: .normal)
        $0.titleLabel?.font = .label1
    }
    private lazy var noticeStackView = UIStackView(arrangedSubviews: [
        recentNoticeLabel,
        viewMoreButton
    ]).then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
    }
    private lazy var bottomCollectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.itemSize = .init(width: self.view.frame.width, height: 81)
    }
    private lazy var bottomCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: bottomCollectionViewFlowLayout
    ).then {
        $0.backgroundColor = .background
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.register(
            NoticeCollectionViewCell.self,
            forCellWithReuseIdentifier: NoticeCollectionViewCell.identifier
        )
        $0.delegate = self
        $0.dataSource = self
    }

    public override func configureNavgationBarLayOutSubviews() {
        super.configureNavgationBarLayOutSubviews()
        
        navigationController?.isNavigationBarHidden = true
    }
    public override func bind() {
        let input = HomeViewModel.Input(
            viewWillApper: viewWillAppearRelay.asObservable(),
            clickAlert: navigationBar.alertButtonTap.asObservable(),
            clickViewMore: viewMoreButton.rx.tap.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        output.viewMode.asObservable()
            .subscribe(onNext: { mode in
                let type = UserDefaultsManager.shared.get(forKey: .homeViewMode)
                self.homeViewType = type as! HomeViewType
            }).disposed(by: disposeBag)
//        viewMoreButton.rx.tap
//            .bind {
//               let dd = UserDefaultsManager.shared.get(forKey: .homeViewMode)
//                self.homeViewType = dd as? HomeViewType ?? .schoolMeal
//                self.view.layoutIfNeeded()
//                self.viewWillAppear(true)
//                self.topCollectionView.reloadData()
//                /*      한번 셀이 바뀐 이후로 다시 안바뀜
//                        셀 사이즈 이상함
//                        bottomsheet, navigationbar 코드 리펙 필요함
//                        viewmodel에 bind을 꼭 해야할까?
//                */
//            }.disposed(by: disposeBag)
    }

    public override func addView() {
        [
            navigationBar,
            profileView,
            scrollView
        ].forEach { view.addSubview($0) }

        scrollView.addSubview(contentView)
        contentView.addSubview(mainView)

       [
            todayTimeTableLabel,
            topCollectionView,
            selfStudyBannerView,
            noticeStackView,
            bottomCollectionView,
       ].forEach { mainView.addSubview($0) }
    }
    
    public override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        profileView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
        }

        scrollView.snp.makeConstraints {
            $0.top.equalTo(profileView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        contentView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalTo(self.view)
        }
        mainView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(self.view.frame.height * 1.8)
        }

        todayTimeTableLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(40)
            $0.leading.equalToSuperview().inset(24)
        }
        topCollectionView.snp.makeConstraints {
            $0.top.equalTo(todayTimeTableLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(350)//TODO: 높이 조절 필요
        }
        selfStudyBannerView.snp.makeConstraints {
            $0.top.equalTo(topCollectionView.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(160)
        }
        noticeStackView.snp.makeConstraints {
            $0.top.equalTo(selfStudyBannerView.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        bottomCollectionView.snp.makeConstraints {
            $0.top.equalTo(recentNoticeLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(350)//TODO: 높이 조절 필요
        }
    }

}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == topCollectionView {
            return 7
        } else {
            return 6
        }
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == topCollectionView {
            switch homeViewType {
            case .timeTable:
                guard let cell = topCollectionView.dequeueReusableCell(withReuseIdentifier: TimeTableCollectionViewCell.identifier, for: indexPath) as? TimeTableCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.setup(
                    period: indexPath.row + 1,
                    image: .alert,
                    subject: "디지털 포렌식"
                )
                return cell
            case .schoolMeal:
                guard let cell = topCollectionView.dequeueReusableCell(withReuseIdentifier: SchoolMealHomeCell.identifier, for: indexPath) as? SchoolMealHomeCell else {
                    return UICollectionViewCell()
                }
                cell.setup(
                    mealTime: "조식",
                    menu: "녹두찰밥\n스팸구이\n시리얼(블루베리)\n우유\n한우궁중떡볶이\n미니고구마파이",
                    kcal: "735.9kcal"
                )
                return cell
            }
        } else {
            guard let cell = bottomCollectionView.dequeueReusableCell(withReuseIdentifier: NoticeCollectionViewCell.identifier, for: indexPath) as? NoticeCollectionViewCell else {
                return UICollectionViewCell()
            }
            
//            cell.setup(title: "[중요] 오리엔테이션날 일정 안내", daysAgo: "1일전", isNew: false)
            return cell
        }
    }

}
