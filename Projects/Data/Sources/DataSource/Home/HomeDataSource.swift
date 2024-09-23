import Foundation

import RxSwift
import RxCocoa

import Starscream

import Core
import Domain
import AppNetwork

protocol HomeDataSource {
    func fetchApplyStatus() -> HomeApplyStatusEntity
}

class HomeDataSourceImpl: WebSocketDelegate, HomeDataSource {
    private let keychain: Keychain
    private var socket: WebSocket?

//    private var applyStatusRelay = HomeApplyStatusEntity(userID: UUID(), userName: "", startTime: "", endTime: "", classroom: "", type: "")
    private var applyStatusRelay = BehaviorRelay<HomeApplyStatusEntity>(value: .init(userID: UUID(), userName: "", startTime: "", endTime: "", classroom: "", type: ""))

    init(keychain: Keychain) {
        self.keychain = keychain
        connectSocket()
    }

    deinit {
        socket?.disconnect()
        socket?.delegate = nil
    }

    func connectSocket() {
        let url = URL(string: "\(URLUtil.socketBaseURL)/main")
        var request = URLRequest(url: url!)
        request.timeoutInterval = 0
        if let token = keychain.load(type: .accessToken) {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        socket = WebSocket(request: request)
        socket?.delegate = self
        socket?.connect()
    }

    func fetchApplyStatus() -> HomeApplyStatusEntity {
        return applyStatusRelay.value
    }

}

extension HomeDataSourceImpl {
    func didReceive(
        event: Starscream.WebSocketEvent,
        client: any Starscream.WebSocketClient
    ) {
        switch event {
        case .connected(let headers):
            socket?.write(string: "")
            print("websocket is connected: \(headers)")

        case .disconnected(let reason, let code):
            print("websocket is disconnected: \(reason) with code: \(code)")

        case .text(let text):
            let homeApplyStatus = try? JSONDecoder().decode(HomeApplyStatusDTO.self, from: text.data(using: .utf8) ?? Data())

            self.applyStatusRelay.accept(homeApplyStatus?.toDomain() ?? .init(userID: UUID(), userName: "", startTime: "", endTime: "", classroom: "", type: ""))

        case .error(let error):
            print("websocket is error = \(error!)")

        default:
            break
        }
    }

}
