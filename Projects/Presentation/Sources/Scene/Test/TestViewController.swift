import UIKit
import AppNetwork

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
    private let calendar = PiCKCalendar(selectedDate: Date(), type: .month)
    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .background
        bind()
    }
    public override func viewDidLayoutSubviews() {
        layout()
    }
    private func bind() {
        button1.rx.tap
            .bind {
                let provider = MoyaProvider<AuthAPI>(plugins: [MoyaLoggingPlugin()])
                
                provider.request(.login(accountID: "wns513", password: "cyj070513##")) { res in
                    switch res {
                    case .success(let result):
                        switch result.statusCode {
                        case 200...299:
                            print("성공이다")
                        default:
                            print("Fail")
                        }
                    case .failure(let err):
                        print(err.localizedDescription)
                    }
                }
            }.disposed(by: disposeBag)
        button2.rx.tap
            .bind {
                let provider = MoyaProvider<NoticeAPI>(plugins: [MoyaLoggingPlugin()])
                
                provider.request(.fetchNoticeList) { res in
                    switch res {
                    case .success(let result):
                        switch result.statusCode {
                        case 200...299:
                            print("성공이다")
                        default:
                            print("Fail")
                        }
                    case .failure(let err):
                        print(err.localizedDescription)
                    }
                }
            }.disposed(by: disposeBag)
        button3.rx.tap
            .bind {
//                TokenStorage.shared.removeToken()
            }.disposed(by: disposeBag)
    }
    private func layout() {
        [
            button1,
            button2,
            button3
            //            calendar
        ].forEach { view.addSubview($0) }
        
        //        calendar.snp.makeConstraints {
        //            $0.center.equalToSuperview()
        //            $0.height.width.equalTo(390)
        //            $0.height.equalTo(390)
        //            $0.width.equalTo(200)
//    }
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
