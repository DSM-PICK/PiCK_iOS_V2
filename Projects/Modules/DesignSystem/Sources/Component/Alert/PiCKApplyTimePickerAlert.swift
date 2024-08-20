import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core

public class PiCKApplyTimePickerAlert: UIViewController {
    private let disposeBag = DisposeBag()

    private var timePickerType: TimePickerType = .classRoom

    public var clickApplyButton: (() -> Void)?
    public var selectedPeriod: ((Int, Int) -> Void)?
    public var selectedTime: ((String, String) -> Void)?

    private let explainLabel = PiCKLabel(
        textColor: .modeBlack,
        font: .label1
    )
    private let periodPickerView = PiCKClassRoomPickerContainerView()
    private let timePickerView = PiCKOutingPickerContainerView()
    private let applyButton = PiCKButton(buttonText: "신청하기")

    public init(type: TimePickerType) {
        self.timePickerType = type
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
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
            .bind(onNext: { [weak self] in
                self?.dismiss(animated: true)
                switch self?.timePickerType {
                case .classRoom:
                    self?.selectedPeriod!(self?.periodPickerView.startPeriodValue ?? 0, self?.periodPickerView.endPeriodValue ?? 0)
                    self?.clickApplyButton!()
                case .outingStart, .outingEnd:
                    let hour = self?.timePickerView.outingHourValue ?? 0
                    let min = self?.timePickerView.outingMinValue ?? 0

                    let hourString = String(format: "%02d", hour)
                    let minString = String(format: "%02d", min)

                    self?.selectedTime!(hourString, minString)
                case .none:
                    return
                }
            }).disposed(by: disposeBag)
    }
    private func layout() {
        [
            explainLabel,
            periodPickerView,
            timePickerView,
            applyButton
        ].forEach { view.addSubview($0) }

        switch timePickerType {
        case .classRoom:
            timePickerView.isHidden = true
            explainLabel.text = "교실 이동 시간을 선택해주세요"
        case .outingStart:
            periodPickerView.isHidden = true
            explainLabel.text = "외출 시작 시간을 선택해주세요"
        case .outingEnd:
            periodPickerView.isHidden = true
            explainLabel.text = "외출 복귀 시간을 선택해주세요"
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
        applyButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(60)
        }
    }

}
