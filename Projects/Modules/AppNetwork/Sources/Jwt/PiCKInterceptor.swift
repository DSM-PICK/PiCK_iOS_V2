import Alamofire
import Moya
import RxSwift
import UIKit
import Core
import KeychainSwift

public class PiCKInterceptor: RequestInterceptor {
    static let shared = PiCKInterceptor()
    private let disposeBag = DisposeBag()
    
    private let keychain = KeychainSwift()
    
    let provider = MoyaProvider<AuthAPI>(plugins: [MoyaLoggingPlugin()])
    private init() { }
    
    public func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard urlRequest.url?.absoluteString.hasPrefix("https://stag-server.xquare.app/dsm-pick") == true,
              let accessToken = TokenStorage.shared.accessToken, // 기기에 저장된 토큰들
              let refreshToken = TokenStorage.shared.refreshToken
        else {
            completion(.success(urlRequest))
            return
        }
        
        var urlRequest = urlRequest
        urlRequest.setValue(accessToken, forHTTPHeaderField: "Bearer")
        urlRequest.setValue(refreshToken, forHTTPHeaderField: "X-Refresh-Token")
        completion(.success(urlRequest))
    }
    
    public func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("retry 진입")
            guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401
        else {
            completion(.doNotRetryWithError(error))
            return
        }
        provider.request(.refreshToken) { res in
            switch res {
            case .success(let result):
                switch result.statusCode {
                case 200...299:
                    if let data = try? JSONDecoder().decode(InterceptorDTO.self, from: result.data) {
                        print("Success To refresh")
                        TokenStorage.shared.accessToken = data.accessToken
                        TokenStorage.shared.refreshToken = data.refreshToken
                    }
                default:
                    print("Failed To refresh")
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
}

struct InterceptorDTO: Codable {
    let accessToken: String
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}
