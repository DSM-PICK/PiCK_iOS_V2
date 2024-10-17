import Foundation

import Moya

import Core
import Domain
import AppNetwork

public enum ProfileAPI {
    case fetchSimpleProfile
    case fetchDetailProfile
    case uploadProfileImage(image: Data)
}

extension ProfileAPI: PiCKAPI {
    public typealias ErrorType = PiCKError

    public var urlType: PiCKURL {
        return .user
    }

    public var urlPath: String {
        switch self {
        case .fetchSimpleProfile:
            return "/simple"
        case .fetchDetailProfile:
            return "/details"
        case .uploadProfileImage:
            return "/profile"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .uploadProfileImage:
            return .patch
        default:
            return .get
        }
    }

    public var task: Moya.Task {
        switch self {
        case .uploadProfileImage(let image):
            var multiformData: [MultipartFormData] = []
            multiformData.append(.init(
                provider: .data(image),
                name: "file",
                fileName: "file.jpg",
                mimeType: "file/jpg"
            ))

            return .uploadMultipart(multiformData)
        default:
            return .requestPlain
        }
    }

    public var pickHeader: TokenType {
        return .accessToken
    }

    public var errorMap: [Int: PiCKError]? {
        return nil
    }

}
