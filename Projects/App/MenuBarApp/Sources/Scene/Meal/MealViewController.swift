import Cocoa
import SnapKit
import Then
import Combine
import MenuBarDesignSystem
import MenuBarNetwork

class MealViewController: BaseNSViewController {
    private let scrollView = NSScrollView()
    private let stackView = NSStackView()
    private let headerView = NSView()
    private let titleLabel = NSTextField(labelWithString: "오늘의 급식")
    private let dateLabel = NSTextField(labelWithString: "")

    private let breakfastSection = MealSectionView(mealType: "조식")
    private let lunchSection = MealSectionView(mealType: "중식")
    private let dinnerSection = MealSectionView(mealType: "석식")

    private let loadingIndicator = NSProgressIndicator()

    private let viewModel = MealViewModel()
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        updateDate()
        bindViewModel()
        viewModel.fetchMeal()
    }

    private func bindViewModel() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.handleState(state)
            }
            .store(in: &cancellables)
    }

    private func handleState(_ state: MealViewModel.State) {
        switch state {
        case .idle:
            break
        case .loading:
            loadingIndicator.isHidden = false
            loadingIndicator.startAnimation(nil)
            scrollView.isHidden = true
        case .loaded(let mealData):
            loadingIndicator.stopAnimation(nil)
            loadingIndicator.isHidden = true
            scrollView.isHidden = false
            breakfastSection.configure(
                menu: mealData.meals.breakfast.menu,
                kcal: mealData.meals.breakfast.cal
            )
            lunchSection.configure(
                menu: mealData.meals.lunch.menu,
                kcal: mealData.meals.lunch.cal
            )
            dinnerSection.configure(
                menu: mealData.meals.dinner.menu,
                kcal: mealData.meals.dinner.cal
            )
        case .error:
            loadingIndicator.stopAnimation(nil)
            loadingIndicator.isHidden = true
            scrollView.isHidden = false
        }
    }

    override func setupUI() {
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.pickBackground.cgColor

        headerView.wantsLayer = true

        titleLabel.do {
            $0.font = NSFont.systemFont(ofSize: 18, weight: .semibold)
            $0.textColor = .pickModeBlack
            $0.alignment = .left
            $0.isEditable = false
            $0.isBordered = false
            $0.backgroundColor = .clear
        }

        dateLabel.do {
            $0.font = NSFont.systemFont(ofSize: 13)
            $0.textColor = .secondaryLabelColor
            $0.alignment = .left
            $0.isEditable = false
            $0.isBordered = false
            $0.backgroundColor = .clear
        }

        stackView.do {
            $0.orientation = .vertical
            $0.spacing = 12
            $0.alignment = .leading
            $0.distribution = .fill
            $0.edgeInsets = NSEdgeInsets(top: 0, left: 20, bottom: 20, right: 20)
            $0.addArrangedSubview(breakfastSection)
            $0.addArrangedSubview(lunchSection)
            $0.addArrangedSubview(dinnerSection)
        }

        scrollView.do {
            $0.documentView = stackView
            $0.hasVerticalScroller = true
            $0.autohidesScrollers = true
            $0.borderType = .noBorder
            $0.backgroundColor = .clear
            $0.drawsBackground = false
        }

        loadingIndicator.do {
            $0.style = .spinning
            $0.controlSize = .regular
            $0.isHidden = true
        }

        headerView.addSubview(titleLabel)
        headerView.addSubview(dateLabel)
        view.addSubview(headerView)
        view.addSubview(scrollView)
        view.addSubview(loadingIndicator)
    }

    override func setupConstraints() {
        headerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(70)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        dateLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        scrollView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        stackView.snp.makeConstraints {
            $0.width.equalTo(scrollView)
        }

        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    private func updateDate() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일 EEEE"
        dateLabel.stringValue = formatter.string(from: Date())
    }
}
