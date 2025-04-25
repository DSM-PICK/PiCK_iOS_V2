import UIKit
import Network

import RxSwift
import RxCocoa

import Core
import DesignSystem

open class BaseViewController<ViewModel: BaseViewModel>: UIViewController, UIGestureRecognizerDelegate {
    public let disposeBag = DisposeBag()
    public var viewModel: ViewModel

    public var viewWillAppearRelay = PublishRelay<Void>()

    private let networkMonitor = NWPathMonitor()

    public var navigationTitleText: String?
    private let navigationTitleLabel = PiCKLabel(
        textColor: .modeBlack,
        font: .pickFont(.body1)
    )

    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        bind()
        configureNavigationBar()
        monitorNetworkStatus()
    }
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewWillAppearRelay.accept(())
        bindAction()
    }
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        addView()
        setLayout()
    }
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureNavgationBarLayOutSubviews()
        setLayoutData()
    }

    open func attribute() {
        // 뷰 관련 코드를 설정하는 함수
        view.backgroundColor = .background

        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    open func configureNavigationBar() {
        // 네비게이션바 관련 코드를 설정하는 함수
        navigationTitleLabel.text = navigationTitleText
        navigationItem.titleView = navigationTitleLabel
    }
    open func configureNavgationBarLayOutSubviews() {
        // viewDidLayoutSubviews에서 네비게이션바 관련 코드를 호출하는 함수
        navigationController?.isNavigationBarHidden = false
    }
    open func bindAction() {
        // Rx 액션을 설정하는 함수
    }
    open func bind() {
        // UI 바인딩을 설정하는 함수
    }
    open func addView() {
        // 서브뷰를 구성하는 함수
    }
    open func setLayout() {
        // 레이아웃을 설정하는 함수
    }
    open func setLayoutData() {
        // 뷰 관련 데이터를 호출하는데 사용하는 함수
    }

    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    private func monitorNetworkStatus() {
        networkMonitor.start(queue: .global())

        let alert = PiCKAlert(
            titleText: "인터넷 연결이 원활하지 않습니다.",
            explainText: "Wifi 또는 셀룰러를 활성화 해주세요.",
            type: .positive
        ) {
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        }

        DispatchQueue.main.async {
            if self.networkMonitor.currentPath.status == .unsatisfied {
                self.present(alert, animated: true)
            }
        }

        networkMonitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }

            DispatchQueue.main.async {
                if path.status == .unsatisfied {
                    if self.presentedViewController == nil {
                        self.present(alert, animated: true)
                    }
                }
            }
        }

    }

}
