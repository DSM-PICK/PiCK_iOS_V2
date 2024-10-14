import Foundation

import RxSwift
import RxCocoa

import Starscream

import Core
import Domain
import AppNetwork

protocol HomeDataSource {
    func fetchApplyStatus() -> Observable<HomeApplyStatusEntity>
}

class HomeDataSourceImpl: WebSocketDelegate, HomeDataSource {
    private let keychain: Keychain
    private var socket: WebSocket?

    private var applyStatusRelay = PublishRelay<HomeApplyStatusEntity>()

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
        request.timeoutInterval = 5
        request.setValue("\(keychain.load(type: .accessToken))", forHTTPHeaderField: "Authorization")
        socket = WebSocket(request: request)
        socket?.delegate = self
        socket?.connect()
    }

    func fetchApplyStatus() -> Observable<HomeApplyStatusEntity> {
        return applyStatusRelay.asObservable()
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
            let homeApplyStatus = try? JSONDecoder().decode(
                HomeApplyStatusDTO.self,
                from: text.data(using: .utf8) ?? Data()
            )

            self.applyStatusRelay.accept(
                homeApplyStatus?.toDomain() ?? .init(
                    userID: nil,
                    userName: nil,
                    startTime: nil,
                    endTime: nil,
                    classroom: nil,
                    type: nil
                )
            )

        case .error(let error):
            print("websocket is error = \(error!)")

        default:
            break
        }
    }

}
