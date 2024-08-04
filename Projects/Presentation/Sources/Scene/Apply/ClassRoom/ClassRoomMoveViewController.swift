import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import DesignSystem

public class ClassRoomMoveViewController: BaseViewController<ClassRoomMoveViewModel> {
    private lazy var currentFloorClassroomArray = BehaviorRelay<[String]>(value: firstFloor)
    let firstFloor = [
        "산학협력부", "새롬홀", "무한 상상실",
        "청죽관", "탁구실", "운동장"
    ]
    let secondFloor = [
        "3-1", "3-2", "3-3", "3-4", "세미나실 2-1",
        "세미나실 2-2", "세미나실 2-3", "SW 1실", "SW 2실",
        "SW 3실", "본부 교무실", "제 3 교무실", "카페테리아",
        "창조실", "방송실", "진로 상담실", "여자 헬스장"
    ]
    let thirdFloor = [
        "2-1", "2-2", "2-3", "2-4", "세미나실 3-1", 
        "세미나실 3-2", "세미나실 3-3", "보안 1실",
        "보안 2실", "제 2 교무실", "그린존", "남자 헬스장"
    ]
    let fourthFloor = [
        "1-1", "1-2", "1-3", "1-4", "세미나실 4-1",
        "세미나실 4-2", "세미나실 4-3", "세미나실 4-4",
        "임베 1실", "임베 2실", "제 1 교무실"
    ]
    let fifthFloor = [
        "음악실", "음악 준비실", "상담실",
        "수학실", "과학실"
    ]

    private let titleLabel = PiCKLabel(text: "교실 이동", textColor: .modeBlack, font: .heading4)
    private let explainLabel = PiCKLabel(text: "자습 감독 선생님께서 수락 후 이동할 수 있습니다.", textColor: .gray600, font: .body2)
    private let segmetedControl = ClassRoomSegmentedControl(items: [
        "1층",
        "2층",
        "3층",
        "4층",
        "5층"
    ]).then {
        $0.selectedSegmentIndex = 0
    }
    private lazy var collectionViewFlowLayout = LeftAlignedCollectionViewFlowLayout().then {
        $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        $0.minimumLineSpacing = 15
        $0.minimumInteritemSpacing = 16
    }
    private lazy var classRoomCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewFlowLayout
    ).then {
        $0.backgroundColor = .background
        $0.register(
            ClassRoomCollectionViewCell.self,
            forCellWithReuseIdentifier: ClassRoomCollectionViewCell.identifier
        )
        $0.contentInsetAdjustmentBehavior = .always
        $0.bounces = false
    }
    private let nextButton = PiCKButton(type: .system, buttonText: "다음", isEnabled: false)

    public override func attribute() {
        super.attribute()

        navigationTitleText = "교실 이동 신청"
    }
    public override func bind() {
        segmetedControl.rx.selectedSegmentIndex
            .map { [weak self] index -> [String] in
                guard let self = self else { return [] }
                switch index {
                case 0: return self.firstFloor
                case 1: return self.secondFloor
                case 2: return self.thirdFloor
                case 3: return self.fourthFloor
                case 4: return self.fifthFloor
                default: return self.firstFloor
                }
            }
            .bind(to: currentFloorClassroomArray)
            .disposed(by: disposeBag)
        
        currentFloorClassroomArray
            .bind(to: classRoomCollectionView.rx.items(
                cellIdentifier: ClassRoomCollectionViewCell.identifier,
                cellType: ClassRoomCollectionViewCell.self
            )) { row, element, cell in
                cell.setup(classRoom: element)
            }
            .disposed(by: disposeBag)
        
        classRoomCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] index in
                self?.nextButton.isEnabled = true
            }).disposed(by: disposeBag)
        
        nextButton.buttonTap
            .bind {
                let vc = PiCKApplyTimePickerAlert()
                self.presentAsCustomDents(view: vc, height: 288)
                self.nextButton.isEnabled = true
            }.disposed(by: disposeBag)
        
    }

    public override func addView() {
        [
            titleLabel,
            explainLabel,
            segmetedControl,
            classRoomCollectionView,
            nextButton
        ].forEach { view.addSubview($0) }
    }
    public override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            $0.leading.equalToSuperview().inset(24)
        }
        explainLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(24)
        }
        segmetedControl.snp.makeConstraints {
            $0.top.equalTo(explainLabel.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(25)
        }
        classRoomCollectionView.snp.makeConstraints {
            $0.top.equalTo(segmetedControl.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview()
        }
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(60)
        }
    }

}
