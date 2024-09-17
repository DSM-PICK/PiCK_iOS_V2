import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import Domain
import DesignSystem

public class HomeViewController: BaseViewController<HomeViewModel> {
    private var homeViewType: HomeViewType = .timeTable

    private var timeTableData = BehaviorRelay<[TimeTableEntityElement]>(value: [])
    private var schoolMealData = BehaviorRelay<[(Int, String, MealEntityElement)]>(value: [])

    private let todayDate = Date()

    private lazy var subViewSize = CGRect(
        x: 0,
        y: 0,
        width: self.view.frame.width,
        height: 0
    )
    private lazy var timeTableHeight = BehaviorRelay<CGFloat>(value: 0)
    private lazy var schoolMealHeight = BehaviorRelay<CGFloat>(value: 0)

    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
    }
    private let contentView = UIView()
    private let mainView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 32
    }

    private lazy var navigationBar = PiCKMainNavigationBar(view: self)

    private let weekendMealPeriodHeaderView = WeekendMealPeriodHeaderView()
    private lazy var profileView = PiCKProfileView()
    private let passHeaderView = HomePassHeaderView()

    private lazy var headerStackView = UIStackView(arrangedSubviews: [
        weekendMealPeriodHeaderView,
        profileView,
        passHeaderView
    ]).then {
        $0.axis = .vertical
        $0.spacing = 20
    }

    private let todaysLabel = PiCKLabel(
        textColor: .gray700,
        font: .label1
    )
    private lazy var timeTableView = HomeTimeTableView(frame: subViewSize)
    private lazy var schoolMealView = HomeSchoolMealView(frame: subViewSize)
    private lazy var mainStackView = UIStackView(arrangedSubviews: [
        todaysLabel,
        timeTableView,
        schoolMealView
    ]).then {
        $0.axis = .vertical
        $0.spacing = 20
    }
    private let selfStudyBannerView = PiCKHomeSelfStudyBannerView()
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
    private lazy var noticeTitleStackView = UIStackView(arrangedSubviews: [
        recentNoticeLabel,
        viewMoreButton
    ]).then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
    }
    private lazy var noticeCollectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.itemSize = .init(width: self.view.frame.width, height: 81)
        $0.minimumLineSpacing = 5
    }
    private lazy var noticeCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: noticeCollectionViewFlowLayout
    ).then {
        $0.backgroundColor = .background
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.register(
            NoticeCollectionViewCell.self,
            forCellWithReuseIdentifier: NoticeCollectionViewCell.identifier
        )
    }
    private lazy var noticeStackView = UIStackView(arrangedSubviews: [
        noticeTitleStackView,
        noticeCollectionView
    ]).then {
        $0.axis = .vertical
        $0.spacing = 20
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

//        viewWillAppearRelay.accept(())
    }
    public override func configureNavgationBarLayOutSubviews() {
        super.configureNavgationBarLayOutSubviews()

        navigationController?.isNavigationBarHidden = true
    }
    public override func bind() {
        let input = HomeViewModel.Input(
            viewWillAppear: viewWillAppearRelay.asObservable(),
            clickAlert: navigationBar.alertButtonTap.asObservable(),
            clickOutingPass: passHeaderView.buttonTap.asObservable(),
            clickViewMoreNotice: viewMoreButton.rx.tap.asObservable(),
            todayDate: todayDate.toString(type: .fullDate)
        )
        let output = viewModel.transform(input: input)

        output.viewMode.asObservable()
            .withUnretained(self)
            .bind { owner, data in
                owner.setupViewType(type: data)
            }.disposed(by: disposeBag)

        output.applyStatusData.asObservable()
            .withUnretained(self)
            .bind { owner, data in
                owner.passHeaderView.isHidden = true
                let ddd = data?.type?.isEmpty
//                owner.passHeaderView.isHidden = ddd!
                owner.passHeaderView.setup(
                    isWait: false,
                    type: OutingType(rawValue: (data?.type)!) ?? .application,
                    startTime: data?.startTime,
                    endTime: data?.endTime,
                    classRoomText: data?.classroom
                )
            }.disposed(by: disposeBag)

        output.weekendMealPeriodData
            .asObservable()
            .withUnretained(self)
            .bind { owner, data in
                owner.weekendMealPeriodHeaderView.isHidden = !data.status
                owner.weekendMealPeriodHeaderView.setup(
                    startPeriodText: data.start,
                    endPeriodText: data.end
                )
            }.disposed(by: disposeBag)

        output.timetableData.asObservable()
            .withUnretained(self)
            .bind { owner, data in
                owner.timeTableData.accept(data)
            }.disposed(by: disposeBag)

        output.schoolMealData.asObservable()
            .withUnretained(self)
            .bind { owner, data in
                owner.schoolMealData.accept(data)
            }.disposed(by: disposeBag)

        output.noticeListData.asObservable()
            .bind(to: noticeCollectionView.rx.items(
                cellIdentifier: NoticeCollectionViewCell.identifier,
                cellType: NoticeCollectionViewCell.self
            )) { row, item, cell in
                cell.adapt(model: item)
            }.disposed(by: disposeBag)

        output.outingPassData.asObservable()
            .withUnretained(self)
            .bind { owner, data in
                let alert = PassView()
                alert.modalTransitionStyle = .crossDissolve
                alert.modalPresentationStyle = .overFullScreen
                owner.present(alert, animated: true)
                alert.setup(
                    name: data.userName,
                    info: "\(data.grade ?? 0)학년 \(data.classNum ?? 0)반 \(data.num ?? 0)번",
                    time: "\(data.start ?? "") ~ \(data.end ?? "")",
                    reason: data.reason,
                    teacher: "\(data.teacherName) 선생님"
                )
            }.disposed(by: disposeBag)

        output.selfStudyData.asObservable()
            .withUnretained(self)
            .bind { owner, data in
                owner.selfStudyBannerView.setup(selfStudyTeacherData: data)
            }.disposed(by: disposeBag)

        output.timeTableHeight.asObservable()
            .withUnretained(self)
            .bind { owner, height in
                if height == 0 {
                    owner.timeTableHeight.accept(50)
                } else {
                    owner.timeTableHeight.accept(height)
                }
//                owner.setLayout()
            }.disposed(by: disposeBag)

        output.schoolMealHeight.asObservable()
            .withUnretained(self)
            .bind { owner, height in
                owner.schoolMealHeight.accept(height)
//                owner.setLayout()
            }.disposed(by: disposeBag)

        output.noticeViewHeight.asObservable()
            .withUnretained(self)
            .bind { owner, height in
                owner.noticeCollectionView.snp.remakeConstraints {
                    $0.height.equalTo(height)
                }
//                owner.setLayout()
            }.disposed(by: disposeBag)
    }

    public override func addView() {
        [
            navigationBar,
            scrollView
        ].forEach { view.addSubview($0) }

        scrollView.addSubview(contentView)

        [
            headerStackView,
            mainView
        ].forEach { contentView.addSubview($0) }

       [
            mainStackView,
            selfStudyBannerView,
            noticeStackView
       ].forEach { mainView.addArrangedSubview($0) }
    }

    public override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }

        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(24)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        contentView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalTo(self.view)
        }

        headerStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        mainView.snp.makeConstraints {
            $0.top.equalTo(headerStackView.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview()
        }

        passHeaderView.snp.makeConstraints {
            $0.height.equalTo(72)
        }

        selfStudyBannerView.snp.makeConstraints {
            $0.height.equalTo(160)
        }
    }

    public override func setLayoutData() {
        let userInfoData = UserDefaultStorage.shared.get(forKey: .userInfoData) as? String
        self.profileView.setup(image: .profile, info: userInfoData ?? "")
    }

    private func setupViewType(type: HomeViewType) {
        switch type {
        case .timeTable:
            self.todaysLabel.text = "오늘의 시간표"
            self.schoolMealView.isHidden = true
            self.timeTableView.isHidden = false
            self.timeTableView.setup(timeTableData: self.timeTableData.value)
            mainStackView.snp.remakeConstraints {
                $0.height.equalTo(self.timeTableHeight.value)
            }
        case .schoolMeal:
            self.todaysLabel.text = "오늘의 급식"
            self.timeTableView.isHidden = true
            self.schoolMealView.isHidden = false
            self.schoolMealView.setup(schoolMealData: self.schoolMealData.value)
            mainStackView.snp.remakeConstraints {
                $0.height.equalTo(self.schoolMealHeight.value)
            }
        }
    }

}
