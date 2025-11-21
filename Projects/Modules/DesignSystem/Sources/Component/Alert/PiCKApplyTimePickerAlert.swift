import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core

public class PiCKApplyTimePickerAlert: UIViewController {
    private let disposeBag = DisposeBag()

    private var timePickerType: PickerType = .classroom

    public var applyButtonDidTap: (() -> Void)?
    public var selectedPeriod: ((Int, Int) -> Void)?
    public var selectedTime: ((String, String) -> Void)?
    public var selectedStudentInfo: ((Int, Int, Int) -> Void)?

    private let explainLabel = PiCKLabel(
        textColor: .modeBlack,
        font: .pickFont(.label1)
    )
    private let periodPickerView = PiCKClassroomPickerContainerView()
    private let timePickerView = PiCKOutingPickerContainerView()
    private let infoPickerView = PiCKInfoContainerView()
    private var applyButton = PiCKButton(buttonText: "신청하기")

    public init(type: PickerType) {
        self.timePickerType = type
        if type == .studentInfo {
            self.applyButton = PiCKButton(buttonText: "선택하기")
        }
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        self.applyButton = PiCKButton(buttonText: "")
        fatalError("init(coder:) has not been implemented")
    }
    public override func viewDidLoad() {
        super.viewDidLoad()

        attribute()
        bind()
    }
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        layout()
    }

    private func attribute() {
        view.backgroundColor = .background
        view.layer.cornerRadius = 20
    }
    private func bind() {
        applyButton.buttonTap
            .bind { [weak self] in
                self?.dismiss(animated: true)
                switch self?.timePickerType {
                case .classroom, .outingPeriod:
                    self?.selectedPeriod!(
                        self?.periodPickerView.startPeriodValue ?? 0,
                        self?.periodPickerView.endPeriodValue ?? 0
                    )
                    self?.applyButtonDidTap!()

                case .outingStart, .outingEnd, .earlyLeave:
                    let hour = self?.timePickerView.outingHourValue ?? 8
                    let min = self?.timePickerView.outingMinValue ?? 0

                    let hourString = String(format: "%02d", hour)
                    let minString = String(format: "%02d", min)

                    self?.selectedTime!(hourString, minString)
                case .studentInfo:
                    let grade = self?.infoPickerView.gradeValue ?? 1
                    let classNum = self?.infoPickerView.classValue ?? 1
                    let number = self?.infoPickerView.numberValue ?? 1
                    self?.selectedStudentInfo!(grade, classNum, number)
                case .none:
                    return
                }
            }.disposed(by: disposeBag)
    }
    private func layout() {
        [
            explainLabel,
            periodPickerView,
            timePickerView,
            infoPickerView,
            applyButton
        ].forEach { view.addSubview($0) }

        switch timePickerType {
        case .classroom:
            timePickerView.isHidden = true
            infoPickerView.isHidden = true
            explainLabel.text = "교실 이동 시간을 선택해주세요"

        case .outingStart:
            periodPickerView.isHidden = true
            infoPickerView.isHidden = true
            explainLabel.text = "외출 시작 시간을 선택해주세요"

        case .outingEnd:
            periodPickerView.isHidden = true
            infoPickerView.isHidden = true
            explainLabel.text = "외출 복귀 시간을 선택해주세요"

        case .outingPeriod:
            timePickerView.isHidden = true
            infoPickerView.isHidden = true
            explainLabel.text = "외출 시작과 복귀 교시를 선택해주세요"

        case .earlyLeave:
            periodPickerView.isHidden = true
            infoPickerView.isHidden = true
            explainLabel.text = "조기귀가 희망 시간을 선택해주세요"
        case .studentInfo:
            periodPickerView.isHidden = true
            timePickerView.isHidden = true
            explainLabel.text = "학번을 선택해주세요"
        }

        explainLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(24)
        }
        periodPickerView.snp.makeConstraints {
            $0.top.equalTo(explainLabel.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(204)
        }
        timePickerView.snp.makeConstraints {
            $0.top.equalTo(explainLabel.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(204)
        }
        infoPickerView.snp.makeConstraints {
            $0.top.equalTo(explainLabel.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(204)
        }
        applyButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(60)
        }
    }

}
