import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import Domain
import DesignSystem

public class AcademicScheduleView: BaseView {
    public var clickYearAndMonth: (Date, Date) -> Void
    public var clickDate: (Date) -> Void

    private lazy var monthAcademicScheduleData = BehaviorRelay<AcademicScheduleEntity>(value: [])
    private lazy var academicScheduleData = BehaviorRelay<AcademicScheduleEntity>(value: [])

    private let todayDate = Date()

    private lazy var calenderView = AcademicScheduleCalendar(
        clickYearAndMonth: { year, month in
            self.clickYearAndMonth(year, month)
        }, clickDate: { date in
            self.clickDate(date)
            if date.toString(type: .fullDate) == self.todayDate.toString(type: .fullDate) {
                self.dateLabel.text = "오늘 \(date.toString(type: .monthAndDayKor))"
                self.dateLabel.changePointColor(targetString: "오늘", color: .main500)
            } else {
                self.dateLabel.text = "\(date.toString(type: .monthAndDayKor))"
            }
        }
    )
    private lazy var dateLabel = PiCKLabel(
        text: "오늘 \(todayDate.toString(type: .monthAndDayKor))",
        textColor: .modeBlack,
        font: .pickFont(.caption1)
    ).then {
        $0.changePointColor(targetString: "오늘", color: .main500)
    }
    private let scheduleLabel = PiCKLabel(
        textColor: .gray800,
        font: .pickFont(.caption2)
    )
    private lazy var labelStackView = UIStackView(arrangedSubviews: [
        dateLabel,
        scheduleLabel
    ]).then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.distribution = .fillEqually
    }
    private lazy var collectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.itemSize = .init(width: self.frame.width, height: 51)
        $0.scrollDirection = .vertical
    }
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewFlowLayout
    ).then {
        $0.backgroundColor = .background
        $0.showsVerticalScrollIndicator = false
        $0.register(
            AcademicScheduleCell.self,
            forCellWithReuseIdentifier: AcademicScheduleCell.identifier
        )
    }
    private lazy var emptyScheduleLabel = PiCKLabel(
        text: "일정이 없습니다.",
        textColor: .gray800,
        font: .pickFont(.caption1),
        isHidden: true
    )

    public func monthAcademicScheduleSetup(
        monthAcademicSchedule: AcademicScheduleEntity
    ) {
        self.monthAcademicScheduleData.accept(monthAcademicSchedule)
    }
    public func academicScheduleSetup(
        academicSchedule: AcademicScheduleEntity
    ) {
        self.academicScheduleData.accept(academicSchedule)
    }

    public init(
        frame: CGRect,
        clickYearAndMonth: @escaping (Date, Date) -> Void,
        clickDate: @escaping (Date) -> Void
    ) {
        self.clickYearAndMonth = clickYearAndMonth
        self.clickDate = clickDate
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func attribute() {
        self.backgroundColor = .background
    }

    public override func bind() {
        academicScheduleData.asObservable()
            .subscribe(onNext: { [weak self] schedule in
                let isEmpty = schedule.isEmpty
                self?.collectionView.isHidden = isEmpty
                self?.emptyScheduleLabel.isHidden = !isEmpty
            }).disposed(by: disposeBag)

        academicScheduleData.asObservable()
            .bind(to: collectionView.rx.items(
                cellIdentifier: AcademicScheduleCell.identifier,
                cellType: AcademicScheduleCell.self
            )) { _, item, cell in
                cell.setup(schedule: item.eventName)
            }.disposed(by: disposeBag)

        monthAcademicScheduleData.asObservable()
            .subscribe(onNext: { [weak self] data in
                self?.calenderView.setup(monthAcademicSchedule: data)
            }).disposed(by: disposeBag)
    }

    public override func layout() {
        [
            calenderView,
            labelStackView,
            collectionView,
            emptyScheduleLabel
        ].forEach { self.addSubview($0) }

        calenderView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(300)
        }
        labelStackView.snp.makeConstraints {
            $0.top.equalTo(calenderView.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(24)
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(labelStackView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(5)
        }
        emptyScheduleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(labelStackView.snp.bottom).offset(72)
        }
    }

}
