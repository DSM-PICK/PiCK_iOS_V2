import Foundation

import RxSwift

public protocol NoticeRepository {
    func fetchNoticeList() -> Single<NoticeListEntity>
    func fetchSimpleNoticeList() -> Single<NoticeListEntity>
    func fetchDetailNotice(id: UUID) -> Single<DetailNoticeEntity>
}
