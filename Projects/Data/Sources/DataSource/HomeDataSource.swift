import Foundation

import RxSwift
import RxCocoa

import Starscream

import Core
import Domain
import AppNetwork

protocol HomeDataSource {
    func fetchApplyStatus() -> Observable<HomeApplyStatusEntity>
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

    func fetchApplyStatus() -> Observable<HomeApplyStatusEntity> {
        return applyStatusRelay
            .compactMap { $0 }
            .asObservable()
    }
}

extension HomeDataSourceImpl {
    func didReceive(event: Starscream.WebSocketEvent, client: any Starscream.WebSocketClient) {
        switch event {
        case .connected:
            handleConnection(isConnected: true)
        case .disconnected(_, _):
            handleConnection(isConnected: false)
        case .error:
            handleConnection(isConnected: false)
        case .text(let text):
            parseSocketData(text)
        case .reconnectSuggested:
            socket?.connect()
        default: break
        }
    }

    private func handleConnection(isConnected: Bool) {
        connectionStatusRelay.accept(isConnected)
        if isConnected {
            socket?.write(string: "")
        } else {
            connectSocket()
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

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        do {
            let status = try decoder.decode(HomeApplyStatusDTO.self, from: data)
            applyStatusRelay.accept(status.toDomain())
        } catch {
            applyStatusRelay.accept(nil)
        }
    }
}
