import Foundation

import RxSwift

import Moya
import RxMoya

import Core
import Domain
import AppNetwork

import FirebaseMessaging

private class AutoLoginCache {
    static var cache: [String: Completable] = [:]
    static let lock = NSLock()
}

class BaseDataSource<API: PiCKAPI> {
    private let keychain: any Keychain

    private let provider: MoyaProvider<API>

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

    func handleAutoLoginFailure() {
        keychain.delete(type: .accessToken)
        keychain.delete(type: .id)
        keychain.delete(type: .password)
        UserDefaultStorage.shared.remove(forKey: .userInfoData)
        NotificationCenter.default.post(name: .autoLoginDidFail, object: nil)
    }

    func autoLogin() -> Completable {
        let key = String(describing: API.self)

        AutoLoginCache.lock.lock()
        if let ongoing = AutoLoginCache.cache[key] {
            AutoLoginCache.lock.unlock()
            return ongoing
        }
        AutoLoginCache.lock.unlock()

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

        let autoLogin = Completable.create { [weak self] completable in
            authProvider.request(.signin(req: loginRequest)) { result in
                switch result {
                case .success(let response):
                    do {
                        let token = try response.map(TokenDTO.self)
                        self?.keychain.save(type: .accessToken, value: token.accessToken)
                        self != nil ? completable(.completed) : completable(.error(MoyaError.requestMapping("")))
                    } catch {
                        self?.handleAutoLoginFailure()
                        completable(.error(error))
                    }
                case .failure(let error):
                    self?.handleAutoLoginFailure()
                    completable(.error(error))
                }
            }
            return Disposables.create()
        }
        .do(
            onError: { _ in
                AutoLoginCache.lock.lock()
                AutoLoginCache.cache.removeValue(forKey: key)
                AutoLoginCache.lock.unlock()
            },
            onCompleted: {
                AutoLoginCache.lock.lock()
                AutoLoginCache.cache.removeValue(forKey: key)
                AutoLoginCache.lock.unlock()
            }
        )

        AutoLoginCache.lock.lock()
        AutoLoginCache.cache[key] = autoLogin
        AutoLoginCache.lock.unlock()

        return autoLogin
    }
}
