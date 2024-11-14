import Foundation

import RxSwift

public class FetchSimpleNoticeListUseCase {
    let repository: NoticeRepository

    public init(repository: NoticeRepository) {
        self.repository = repository
    }

    public func execute() -> Single<NoticeListEntity> {
        return repository.fetchSimpleNoticeList()
    }

}
