import Foundation

import RxSwift

import Moya
import RxMoya

import Core
import Domain
import AppNetwork

import FirebaseMessaging

class BaseDataSource<API: PiCKAPI> {
    private let keychain: any Keychain

    private let provider: MoyaProvider<API>

    private static var ongoingAutoLogin: Completable?

    init(keychain: any Keychain) {
        self.keychain = keychain
        self.provider = MoyaProvider<API>(plugins: [MoyaLoggingPlugin()])
    }

    func request(_ api: API) -> Single<Response> {
        return .create { single in
            var disposables: [Disposable] = []
                disposables.append(
                    self.defaultRequest(api)
                        .subscribe(
                            onSuccess: { single(.success($0)) },
                            onFailure: { single(.failure($0)) }
                        )
                )
            return Disposables.create(disposables)
        }
    }
}

private extension BaseDataSource {
    func defaultRequest(_ api: API, isRetry: Bool = false) -> Single<Response> {
        return provider.rx
            .request(api)
            .timeout(.seconds(120), scheduler: MainScheduler.asyncInstance)
            .catch { [weak self] error in
                guard let self = self else { return .error(error) }

                if let moyaError = error as? MoyaError,
                   let statusCode = moyaError.response?.statusCode,
                   statusCode == 401,
                   !isRetry {
                    return self.autoLogin()
                        .andThen(self.defaultRequest(api, isRetry: true))
                }

                guard let code = (error as? MoyaError)?.response?.statusCode else {
                    return .error(error)
                }
                return .error(
                    api.errorMap?[code] ??
                    PiCKError.error(
                        message: (try? (error as? MoyaError)?
                            .response?
                            .mapJSON() as? NSDictionary)?["message"] as? String ?? "",
                        errorBody: [:]
                    )
                )
            }
    }

    func isApiNeedsAccessToken(_ api: API) -> Bool {
        return api.pickHeader == .accessToken
    }

    func autoLogin() -> Completable {
        if let ongoing = Self.ongoingAutoLogin {
            return ongoing
        }

        let accountID = keychain.load(type: .id)
        let password = keychain.load(type: .password)

        guard accountID != "Failed To Load Keychain Value",
              password != "Failed To Load Keychain Value" else {
            keychain.delete(type: .accessToken)
            keychain.delete(type: .id)
            keychain.delete(type: .password)
            UserDefaultStorage.shared.remove(forKey: .userInfoData)

            NotificationCenter.default.post(name: .autoLoginDidFail, object: nil)

            return .error(PiCKError.error(message: "No saved credentials", errorBody: [:]))
        }

        let loginRequest = SigninRequestParams(
            accountID: accountID,
            password: password,
            deviceToken: Messaging.messaging().fcmToken ?? nil
        )

        let authProvider = MoyaProvider<AuthAPI>(plugins: [MoyaLoggingPlugin()])

        let autoLogin = authProvider.rx
            .request(.signin(req: loginRequest))
            .timeout(.seconds(120), scheduler: MainScheduler.asyncInstance)
            .map(TokenDTO.self)
            .do(onSuccess: { [weak self] token in
                self?.keychain.save(type: .accessToken, value: token.accessToken)
            })
            .asCompletable()
            .catch { [weak self] error in
                self?.keychain.delete(type: .accessToken)
                self?.keychain.delete(type: .id)
                self?.keychain.delete(type: .password)
                UserDefaultStorage.shared.remove(forKey: .userInfoData)

                NotificationCenter.default.post(name: .autoLoginDidFail, object: nil)

                return .error(error)
            }
            .do(
                onCompleted: { Self.ongoingAutoLogin = nil },
                onError: { _ in Self.ongoingAutoLogin = nil }
            )
            .share()

        Self.ongoingAutoLogin = autoLogin
        return autoLogin
    }
}
