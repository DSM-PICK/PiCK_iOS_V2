import Foundation

import Moya
import RxSwift
import RxMoya

import AppNetwork
import Domain

protocol NoticeDataSource {
    func fetchNoticeList() -> Single<Response>
    func fetchSimpleNoticeList() -> Single<Response>
    func fetchDetailNotice(id: UUID) -> Single<Response>
}

class NoticeDataSourceImpl: BaseDataSource<NoticeAPI>, NoticeDataSource {
    func fetchNoticeList() -> Single<Response> {
        return request(.fetchNoticeList)
            .filterSuccessfulStatusCodes()
    }

    func fetchSimpleNoticeList() -> Single<Response> {
        return request(.fetchSimpleNoticeList)
            .filterSuccessfulStatusCodes()
    }

    func fetchDetailNotice(id: UUID) -> Single<Response> {
        return request(.fetchDetailNotice(id: id))
            .filterSuccessfulStatusCodes()
    }

}
