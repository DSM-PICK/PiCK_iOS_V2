import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core

public class PiCKCalendarAlert: UIViewController {
    private let disposeBag = DisposeBag()

    private var dateOnTap: (Date) -> Void

    private var calendarType: CalendarType

    private let backgroundView = UIView().then {
        $0.backgroundColor = .background
    }
    private lazy var calendarView = PiCKCalendarView(
        calnedarType: calendarType,
        dateOnTap: { date in
            self.dismiss(animated: true) {
                self.dateOnTap(date)
            }
        }
    )
    private let toggleButton = PiCKImageButton(image: .topArrow, imageColor: .main500)

    public func setupDate(
        date: Date
    ) {
        self.calendarView.setupDate(date: date)
    }

    public init(
        calendarType: CalendarType,
        dateOnTap: @escaping (Date) -> Void
    ) {
        self.calendarType = calendarType
        self.dateOnTap = dateOnTap
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .placeholderText
        bind()
    }
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        layout()
    }
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true)
    }

    private func bind() {
        self.toggleButton.buttonDidTap
            .bind { [weak self] in
                self?.dismiss(animated: true)
            }.disposed(by: disposeBag)
    }
    private func layout() {
        view.addSubview(backgroundView)
        [
            calendarView,
            toggleButton
        ].forEach { backgroundView.addSubview($0) }

        switch calendarType {
        case .schoolMealMonth:
            self.backgroundView.layer.roundCorners(
                cornerRadius: 20,
                byRoundingCorners: [.bottomLeft, .bottomRight]
            )

            backgroundView.snp.makeConstraints {
                $0.top.leading.trailing.equalToSuperview()
                $0.height.equalTo(379)
            }
            calendarView.snp.makeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide)
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalToSuperview().inset(44)
            }
            toggleButton.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.bottom.equalToSuperview().inset(10)
            }
        case .selfStudyMonth:
            self.backgroundView.layer.roundCorners(
                cornerRadius: 20,
                byRoundingCorners: [.topLeft, .topRight]
            )

            backgroundView.snp.makeConstraints {
                $0.leading.trailing.bottom.equalToSuperview()
                $0.height.equalTo(379)
            }
            toggleButton.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalToSuperview().inset(10)
            }
            calendarView.snp.makeConstraints {
                $0.top.leading.trailing.equalToSuperview()
                $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(8)
            }

            self.toggleButton.setImage(.bottomArrow, for: .normal)
        default:
            return
        }
    }

}
