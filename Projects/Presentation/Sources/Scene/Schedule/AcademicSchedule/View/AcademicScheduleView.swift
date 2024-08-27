import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import Domain
import DesignSystem

public class AcademicScheduleView: BaseView {
    public var clickDate: (Date) -> Void

    private lazy var monthAcademicScheduleData = BehaviorRelay<AcademicScheduleEntity>(value: [])
    private lazy var academicScheduleData = BehaviorRelay<AcademicScheduleEntity>(value: [])

    private let todayDate = Date()

    private lazy var calenderView = AcademicScheduleCalneder(clickDate: { date in
        self.clickDate(date)
        self.dateLabel.text = "\(date.toString(type: .monthAndDay))"
    })
    private lazy var dateLabel = PiCKLabel(
        text: "\(todayDate.toString(type: .monthAndDay))",
        textColor: .modeBlack,
        font: .caption1
    )
    private let scheduleLabel = PiCKLabel(textColor: .gray800, font: .caption2)
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
            forCellWithReuseIdentifier: AcademicScheduleCell.identifier)
    }

    public func monthAcademicScheduleSetup(
        monthAcademicSchedule: AcademicScheduleEntity
    ) {
        self.calenderView.setup(monthAcademicSchedule: monthAcademicSchedule)
        self.monthAcademicScheduleData.accept(monthAcademicSchedule)
    }
    public func academicScheduleSetup(
        academicSchedule: AcademicScheduleEntity
    ) {
        self.academicScheduleData.accept(academicSchedule)
    }

    public init(
        frame: CGRect, clickDate: @escaping (Date) -> Void
    ) {
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
//        monthAcademicScheduleData.asObservable()
//            .bind(to: collectionView.rx.items(
//                cellIdentifier: AcademicScheduleCell.identifier,
//                cellType: AcademicScheduleCell.self
//            )) { row, item, cell in
//                cell.setup(schedule: item.eventName)
//            }.disposed(by: disposeBag)
        
        academicScheduleData.asObservable()
            .bind(to: collectionView.rx.items(
                cellIdentifier: AcademicScheduleCell.identifier,
                cellType: AcademicScheduleCell.self
            )) { row, item, cell in
                cell.setup(schedule: item.eventName)
            }.disposed(by: disposeBag)
        calenderView.setup(monthAcademicSchedule: monthAcademicScheduleData.value)
    }

    public override func layout() {
        [
            calenderView,
            labelStackView,
            collectionView
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
    }

}
