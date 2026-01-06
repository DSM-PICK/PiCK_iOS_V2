import Foundation

import RxSwift
import RxCocoa

import Core
import Domain
import AppNetwork

protocol HomeDataSource {
    func fetchApplyStatus() -> Observable<HomeApplyStatusEntity>
}

class HomeDataSourceImpl: NSObject, HomeDataSource {
    private let keychain: Keychain
    private var task: URLSessionDataTask?
    private var buffer = ""
    private var isConnecting = false

    private var applyStatusRelay = PublishRelay<HomeApplyStatusEntity>()

    init(keychain: Keychain) {
        self.keychain = keychain
        super.init()
        connectSSE()
    }

    func connectSSE() {
        guard !isConnecting else { return }
        isConnecting = true

        let url = URL(string: "\(URLUtil.baseURL)/event")!
        var request = URLRequest(url: url)

        request.httpMethod = "GET"
        request.timeoutInterval = .infinity
        request.setValue("text/event-stream", forHTTPHeaderField: "Accept")
        request.setValue(
            "Bearer \(keychain.load(type: .accessToken))",
            forHTTPHeaderField: "Authorization"
        )

        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = .infinity

        let session = URLSession(
            configuration: configuration,
            delegate: self,
            delegateQueue: nil
        )

        task = session.dataTask(with: request)
        task?.resume()
    }

    func fetchApplyStatus() -> Observable<HomeApplyStatusEntity> {
        return applyStatusRelay.asObservable()
    }

}

extension HomeDataSourceImpl: URLSessionDataDelegate {

    func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        didReceive response: URLResponse,
        completionHandler: @escaping (URLSession.ResponseDisposition) -> Void
    ) {
        print("SSE is connected: \(response)")
        isConnecting = false
        completionHandler(.allow)
    }

    func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        didReceive data: Data
    ) {
        guard let chunk = String(data: data, encoding: .utf8) else { return }
        buffer += chunk

        while let range = buffer.range(of: "\n\n") {
            let rawEvent = String(buffer[..<range.lowerBound])
            buffer.removeSubrange(..<range.upperBound)
            handle(event: rawEvent)
        }
    }

    func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didCompleteWithError error: Error?
    ) {
        isConnecting = false

        if let error = error {
            print("SSE is error = \(error)")
        } else {
            print("SSE is disconnected")
        }

        print("Reconnecting SSE")
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            self?.buffer = ""
            self?.connectSSE()
        }
    }
}

private extension HomeDataSourceImpl {
    func handle(event raw: String) {
        let dataLines = raw
            .split(separator: "\n")
            .filter { $0.hasPrefix("data:") }
            .map {
                $0.replacingOccurrences(of: "data:", with: "")
                    .trimmingCharacters(in: .whitespaces)
            }

        let jsonString = dataLines.joined(separator: "\n")
        print("SSE received text: \(jsonString)")

        guard let data = jsonString.data(using: .utf8),
              let dto = try? JSONDecoder().decode(
                HomeApplyStatusDTO.self,
                from: data
              ) else {
            return
        }

        applyStatusRelay.accept(dto.toDomain())
    }
}
