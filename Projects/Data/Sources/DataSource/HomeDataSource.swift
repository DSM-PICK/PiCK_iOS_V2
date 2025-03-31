import Foundation

import RxSwift
import RxCocoa

import Starscream

import Core
import Domain
import AppNetwork

protocol HomeDataSource {
    func fetchApplyStatus() -> Observable<HomeApplyStatusEntity?>
    func connectSocket()
    var isConnected: Bool { get }
}

class HomeDataSourceImpl: WebSocketDelegate, HomeDataSource {
    private let keychain: Keychain
    private var socket: WebSocket?
    private let disposeBag = DisposeBag()
    private var applyStatusRelay = BehaviorRelay<HomeApplyStatusEntity?>(value: nil)
    private var connectionStatusRelay = BehaviorRelay<Bool>(value: false)

    var isConnected: Bool {
        return connectionStatusRelay.value
    }

    init(keychain: Keychain) {
        self.keychain = keychain
        connectSocket()
    }

    func connectSocket() {
        let url = URL(string: "\(URLUtil.socketBaseURL)/main")
        var request = URLRequest(url: url!)
        request.timeoutInterval = 5
        request.setValue("\(keychain.load(type: .accessToken))", forHTTPHeaderField: "Authorization")
        socket = WebSocket(request: request)
        socket?.delegate = self
        socket?.connect()
    }

    public func fetchApplyStatus() -> Observable<HomeApplyStatusEntity?> {
        return applyStatusRelay.asObservable()
    }
}

extension HomeDataSourceImpl {
    private func handleDisconnection() {
        connectionStatusRelay.accept(false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.connectSocket()
        }
    }

    public func didReceive(event: Starscream.WebSocketEvent, client: any Starscream.WebSocketClient) {
        switch event {
        case .connected:
            connectionStatusRelay.accept(true)
            socket?.write(string: "")
        case .disconnected:
            handleDisconnection()
        case .error:
            handleDisconnection()
        case .text(let text):
            parseSocketData(text)
        case .reconnectSuggested:
            socket?.connect()
        case .cancelled:
            handleDisconnection()
        default:
            break
        }
    }

    private func parseSocketData(_ text: String) {
        guard
            let data = text.data(using: .utf8),
            text.trimmingCharacters(in: .whitespacesAndNewlines) != "null"
        else {
            applyStatusRelay.accept(nil)
            return
        }
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let status = try decoder.decode(HomeApplyStatusDTO.self, from: data)
            applyStatusRelay.accept(status.toDomain())
        } catch {
            applyStatusRelay.accept(nil)
        }
    }
}
