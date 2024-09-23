import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa
import RxFlow

import Moya

import Core
import Domain
import DesignSystem

public class TestViewController: UIViewController, Stepper {
    public var steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()
    private let keychain = KeychainImpl()

    private let button1 = PiCKButton(type: .system, buttonText: "login")
    private let button2 = PiCKButton(type: .system, buttonText: "test request")
    private let button3 = PiCKButton(type: .system, buttonText: "remove all")
    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .background
        bind()
    }
    public override func viewDidLayoutSubviews() {
        layout()
    }

    private func bind() {
        button1.buttonTap
            .bind {
                let alert = PassView()
                alert.modalTransitionStyle = .crossDissolve
                alert.modalPresentationStyle = .overFullScreen
                self.present(alert, animated: true)
            }.disposed(by: disposeBag)
    }
//    private func bind() {
//        button1.rx.tap
//            .bind {
//                let provider = MoyaProvider<AuthAPI>(plugins: [MoyaLoggingPlugin()])
//                
//                provider.request(.login(req: .init(accountID: "cyj513", password: "cyj070513##"))) { res in
//                    switch res {
//                    case .success(let result):
//                        switch result.statusCode {
//                        case 200...299:
//                            if let data = try? JSONDecoder().decode(TestDTO.self, from: result.data) {
//                                print("로그인 성공")
//                                TokenStorage.shared.accessToken = data.accessToken
//                                TokenStorage.shared.refreshToken = data.refreshToken
//                            }
//                        default:
//                            print("Fail")
//                        }
//                    case .failure(let err):
//                        print(err.localizedDescription)
//                    }
//                }
//            }.disposed(by: disposeBag)
//        button2.rx.tap
//            .bind {
//                let provider = MoyaProvider<NoticeAPI>(plugins: [MoyaLoggingPlugin()])
//                
//                provider.request(.fetchNoticeList) { res in
//                    switch res {
//                    case .success(let result):
//                        switch result.statusCode {
//                        case 200...299:
//                            print("공지 로드 성공")
//                        default:
//                            print("Fail")
//                        }
//                    case .failure(let err):
//                        print(err.localizedDescription)
//                    }
//                }
//            }.disposed(by: disposeBag)
//        button3.rx.tap
//            .bind {
//                TokenStorage.shared.removeToken()
//                print("토큰 삭제")
//            }.disposed(by: disposeBag)
//    }

    private func layout() {
        [
            button1,
            button2,
            button3
        ].forEach { view.addSubview($0) }

        button1.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(100)
            $0.width.equalTo(300)
        }
        button2.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(200)
            $0.width.equalTo(300)
        }
        button3.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(300)
            $0.width.equalTo(300)
        }
    }

}
