import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import FSCalendar

import Core

public class PiCKCalendarView: BaseView, FSCalendarDelegateAppearance {

    private lazy var calendar = FSCalendar().then {
        $0.scope = .week
        $0.backgroundColor = .red

        //MARK: 헤더 설정
        $0.locale = Locale(identifier: "ko_KR")
        $0.appearance.weekdayTextColor = .modeBlack
        $0.appearance.weekdayFont = .systemFont(ofSize: 15)
        $0.appearance.headerTitleColor = .modeBlack
        $0.appearance.headerMinimumDissolvedAlpha = 0.0
        $0.headerHeight = 40
        $0.appearance.headerDateFormat = "yyyy년 MM월"
        //MARK: 셀 설정
        //선택한 셀 텍스트색
        $0.appearance.titleSelectionColor = .modeBlack
        //선택한 셀 배경색
        $0.appearance.selectionColor = .background
        //선택한 셀 borderColor
        $0.appearance.borderSelectionColor = .main100
        //오늘 날짜 셀 텍스트색
        $0.appearance.titleTodayColor = .modeBlack
        //오늘 날짜 셀 배경색
        $0.appearance.todayColor = .main100
        //오늘 날짜 선택시 배경색
        $0.appearance.todaySelectionColor = .main100
    }
    private let previousButton = PiCKImageButton(image: .leftArrow, imageColor: .modeBlack)
    private let nextButton = PiCKImageButton(image: .rightArrow, imageColor: .modeBlack)
    private let toggleButton = PiCKImageButton(image: .bottomArrow, imageColor: .main500)

    public override func layout() {
        self.addSubview(calendar)
        [
            previousButton,
            nextButton,
            toggleButton
        ].forEach { calendar.addSubview($0) }

        calendar.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        previousButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(5)
            $0.trailing.equalTo(calendar.calendarHeaderView.snp.leading)//.offset(30)
        }
        toggleButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }

}

//struct CalendarSheetModel {
//    let date: Date
//    let day: Int
//}
//
//public enum CalendarType {
//    case week
//    case month
//}
//
//public class PiCKCalendarView: BaseView {
//    public var selectedDate: Date {
//        didSet {
//            dateLabel.text = "\(selectedDate.year)년 \(selectedDate.month)월"
//            datesCollectionView.reloadData()
//        }
//    }
//    private var type: CalendarType = .week
//    private var presentViewController = UIViewController()
//
//    private var isAppear = false
//    public var onDateSelected: ((Date) -> Void)?
//    private var isWeeklyView = false
//
//    private var selectedDateString: String {
//        "\(selectedDate.year)년 \(selectedDate.month)월"
//    }
//
//    private let dateLabel = PiCKLabel(
//        textColor: .modeBlack,
//        font: .label1
//    )
//    private let previousButton = PiCKImageButton(image: .leftArrow, imageColor: .modeBlack)
//    private let nextButton = PiCKImageButton(image: .rightArrow, imageColor: .modeBlack)
//
//    private let arrowButton = PiCKImageButton(image: .bottomArrow, imageColor: .main500)
//
//    private let weekDaysStackView = UIStackView().then {
//        $0.axis = .horizontal
//        $0.distribution = .fillEqually
//        $0.alignment = .center
//    }
//
//    private lazy var collectionViewFlowLayout = UICollectionViewFlowLayout().then {
//        $0.itemSize = .init(width: 24, height: 24)
//        $0.minimumInteritemSpacing = 0
//        $0.minimumLineSpacing = 0
//    }
//
//    private lazy var datesCollectionView = UICollectionView(
//        frame: .zero,
//        collectionViewLayout: collectionViewFlowLayout
//    ).then {
//        $0.backgroundColor = .background
//        $0.register(
//            PiCKDateCell.self,
//            forCellWithReuseIdentifier: PiCKDateCell.identifier
//        )
//        $0.delegate = self
//        $0.dataSource = self
//    }
//
//    public init(
//        selectedDate: Date,
//        type: CalendarType,
//        presentViewController: UIViewController? = UIViewController()
//    ) {
//        self.selectedDate = selectedDate
//        self.type = type
//        self.presentViewController = presentViewController ?? UIViewController()
//        super.init(frame: .zero)
//        setupWeekDays()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    public override func attribute() {
//        self.backgroundColor = .red
//    }
//    public override func bind() {
//        previousButton.buttonTap
//            .bind(onNext: { [weak self] in
//                self?.selectedDate = Calendar.current.date(byAdding: .month, value: -1, to: self!.selectedDate) ?? self!.selectedDate
//            }).disposed(by: disposeBag)
//
//        nextButton.buttonTap
//            .bind(onNext: { [weak self] in
//                self?.selectedDate = Calendar.current.date(byAdding: .month, value: -1, to: self!.selectedDate) ?? self!.selectedDate
//            }).disposed(by: disposeBag)
//
//        arrowButton.buttonTap
//            .bind(onNext: { [weak self] in
//                let vc = PiCKCalendarViewController()
//                let slideInPresentationDelegate = SlideDownPresentationAnimator(height: 379)
//                
////                vc.transitioningDelegate = slideInPresentationDelegate
//                vc.modalPresentationStyle = .custom
//                self?.presentViewController.present(vc, animated: true)
//            }).disposed(by: disposeBag)
//    }
//
//    @objc private func toggleView() {
//        isWeeklyView.toggle()
////        toggleViewButton.setTitle(isWeeklyView ? "월간 보기" : "주간 보기", for: .normal)
//        datesCollectionView.reloadData()
//    }
//
//
//    public override func layout() {
//        [
//            previousButton,
//            nextButton,
//            dateLabel,
//            arrowButton,
//            weekDaysStackView,
//            datesCollectionView
//        ].forEach { self.addSubview($0) }
//
//        previousButton.snp.makeConstraints {
//            $0.centerY.equalTo(dateLabel)
//            $0.leading.equalToSuperview().offset(24)
//        }
//
//        dateLabel.snp.makeConstraints {
//            $0.centerX.equalToSuperview()
//            $0.top.equalToSuperview().inset(20)
//        }
//
//        nextButton.snp.makeConstraints {
//            $0.centerY.equalTo(dateLabel)
//            $0.trailing.equalToSuperview().offset(-24)
//        }
//
//        weekDaysStackView.snp.makeConstraints {
//            $0.top.equalTo(dateLabel.snp.bottom).offset(10)
//            $0.leading.trailing.equalToSuperview().inset(24)
//            $0.height.equalTo(20)
//        }
//
//        datesCollectionView.snp.makeConstraints {
//            $0.top.equalTo(weekDaysStackView.snp.bottom).offset(10)
//            $0.leading.equalToSuperview().offset(24)
//            $0.trailing.equalToSuperview().offset(-24)
//            $0.bottom.equalToSuperview().offset(-56)
//        }
//        
//        arrowButton.snp.makeConstraints {
//            $0.centerX.equalToSuperview()
//            $0.bottom.equalToSuperview().inset(10)
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
//            UIView.animate(withDuration: 0.3) {
//                self.isAppear = true
//                self.datesCollectionView.alpha = 1
//            }
//        }
//    }
//
//    private func setupWeekDays() {
//        let weekDays = ["일", "월", "화", "수", "목", "금", "토"]
//        for day in weekDays {
//            let label = PiCKLabel(
//                text: day,
//                textColor: .modeBlack,
//                font: .caption1,
//                alignment: .center
//            )
//            weekDaysStackView.addArrangedSubview(label)
//        }
//    }
//
//    private func fetchAllDates() -> [CalendarSheetModel] {
//        let calendar = Calendar.current
//
//        // 현재 월의 날짜들 가져오기
//        var days = selectedDate.fetchAllDatesInCurrentMonth()
//            .map { CalendarSheetModel(date: $0, day: $0.day) }
//
//        // 첫 주의 요일 계산
//        let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? .init())
//
//        // 이전 월의 날짜들 채우기
//        if let previousMonth = calendar.date(byAdding: .month, value: -1, to: selectedDate) {
//            let previousMonthDays = previousMonth.fetchAllDatesInCurrentMonth()
//            for day in (previousMonthDays.count - (firstWeekday - 1)..<previousMonthDays.count).reversed() {
//                days.insert(CalendarSheetModel(date: previousMonthDays[day], day: previousMonthDays[day].day), at: 0)
//            }
//        }
//
//        // 마지막 주의 요일 계산
//        let lastWeekday = calendar.component(.weekday, from: days.last?.date ?? .init())
//
//        // 다음 월의 날짜들 채우기
//        if let nextMonth = calendar.date(byAdding: .month, value: 1, to: selectedDate) {
//            let nextMonthDays = nextMonth.fetchAllDatesInCurrentMonth()
//            for day in 0..<(7 - lastWeekday) {
//                days.append(CalendarSheetModel(date: nextMonthDays[day], day: nextMonthDays[day].day))
//            }
//        }
//
//        return days
//    }
//
//    private func fetchDatesForSelectedWeek() -> [CalendarSheetModel] {
//        let calendar = Calendar.current
//        var days = [CalendarSheetModel]()
//
//        // 현재 선택된 날짜의 주의 날짜들 가져오기
//        let startOfWeek = calendar.dateInterval(of: .weekOfMonth, for: selectedDate)?.start ?? selectedDate
//        for i in 0..<7 {
//            if let date = calendar.date(byAdding: .day, value: i, to: startOfWeek) {
//                days.append(CalendarSheetModel(date: date, day: date.day))
//            }
//        }
//
//        return days
//    }
//}
//
//extension PiCKCalendar: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
//    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        switch type {
//        case .week:
//            return fetchDatesForSelectedWeek().count
//        case .month:
//            return fetchAllDates().count
//        }
//    }
//
//    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PiCKDateCell.identifier, for: indexPath) as? PiCKDateCell
//        else { return UICollectionViewCell() }
////        let model = fetchAllDates()[indexPath.row]
//        let model: CalendarSheetModel
//        switch type {
//        case .week:
//            model = fetchDatesForSelectedWeek()[indexPath.item]
//        case .month:
//            model = fetchAllDates()[indexPath.item]
//        }
//
//
//        if model.day != -1 {
//            cell.setup(date: "\(model.day)", textColor: model.date.month == selectedDate.month ? .modeBlack : .gray)
//            cell.backgroundColor = model.date.isSameDay(selectedDate) ? .main100 : .clear
//        } else {
//            cell.setup(date: "")
//            cell.backgroundColor = .clear
//        }
//
//        return cell
//    }
//
//    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let size = collectionView.frame.width / 7
//        return CGSize(width: size, height: size)
//    }
//
//    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//
//    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 10
//    }
//
//    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let model: CalendarSheetModel
//                
//        switch isWeeklyView {
//        case true:
//            model = fetchDatesForSelectedWeek()[indexPath.item]
//        case false:
//            model = fetchAllDates()[indexPath.item]
//        }
//        
//        if model.day != -1 {
//            selectedDate = model.date
//            onDateSelected?(selectedDate)
//        }
//    }
//
//}
//import UIKit
//
//class SlideDownPresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
//    let height: CGFloat
//
//    init(height: CGFloat) {
//        self.height = height
//    }
//
//    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
//        return 0.3
//    }
//
//    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        guard let toViewController = transitionContext.viewController(forKey: .to) else {
//            return
//        }
//
//        let containerView = transitionContext.containerView
//        let duration = transitionDuration(using: transitionContext)
//        let finalFrame = transitionContext.finalFrame(for: toViewController)
//
//        let startFrame = CGRect(x: 0, y: -height, width: finalFrame.width, height: height)
//        let endFrame = CGRect(x: 0, y: 0, width: finalFrame.width, height: height)
//
//        toViewController.view.frame = startFrame
//        containerView.addSubview(toViewController.view)
//
//        UIView.animate(withDuration: duration, animations: {
//            toViewController.view.frame = endFrame
//        }, completion: { finished in
//            transitionContext.completeTransition(finished)
//        })
//    }
//}
//
//class SlideUpDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
//    let height: CGFloat
//
//    init(height: CGFloat) {
//        self.height = height
//    }
//
//    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
//        return 0.3
//    }
//
//    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        guard let fromViewController = transitionContext.viewController(forKey: .from) else {
//            return
//        }
//
//        let containerView = transitionContext.containerView
//        let duration = transitionDuration(using: transitionContext)
//        let startFrame = fromViewController.view.frame
//        let endFrame = startFrame.offsetBy(dx: 0, dy: -startFrame.height)
//
//        UIView.animate(withDuration: duration, animations: {
//            fromViewController.view.frame = endFrame
//        }, completion: { finished in
//            fromViewController.view.removeFromSuperview()
//            transitionContext.completeTransition(finished)
//        })
//    }
//}
