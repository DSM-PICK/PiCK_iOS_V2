import Foundation

import RxSwift

public class FetchDetailNoticeUseCase {
    let repository: NoticeRepository

    public init(repository: NoticeRepository) {
        self.repository = repository
    }

    public func execute(id: UUID) -> Single<DetailNoticeEntity> {
        return repository.fetchDetailNotice(id: id)
    }

}
