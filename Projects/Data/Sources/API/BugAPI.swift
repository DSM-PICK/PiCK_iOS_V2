import Foundation

import Moya

import Core
import Domain
import AppNetwork

public enum BugAPI {
    case uploadImage(images: [Data])
    case bugReport(req: BugRequestParams)
}

extension BugAPI: PiCKAPI {
    public typealias ErrorType = PiCKError

    public var urlType: PiCKURL {
        .bug
    }

    public var urlPath: String {
        switch self {
        case .uploadImage:
            return "/upload"
        case .bugReport:
            return "/message"
        }
    }

    public var method: Moya.Method {
        return .post
    }

    public var task: Moya.Task {
        switch self {
        case .uploadImage(let images):
            var multiformData: [MultipartFormData] = [
                .init(
                    provider: .data(Data()),
                    name: ""
                )
            ]

            for image in images {
                multiformData.append(.init(
                    provider: .data(image),
                    name: "file",
                    fileName: "file.jpg",
                    mimeType: "file/jpg"
                ))
            }

            return .uploadMultipart(multiformData)

        case .bugReport(let req):
            return .requestParameters(
                parameters: [
                    "title": req.title,
                    "model": req.model,
                    "content": req.content,
                    "file_name": req.fileName
                ], encoding: JSONEncoding.default)
        }
    }

    public var pickHeader: TokenType {
        return .accessToken
    }

    public var errorMap: [Int: PiCKError]? {
        return nil
    }

}
