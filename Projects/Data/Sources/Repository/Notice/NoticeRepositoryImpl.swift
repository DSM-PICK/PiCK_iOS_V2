import Foundation

import RxSwift

import Domain

class NoticeRepositoryImpl: NoticeRepository {
    private let remoteDataSource: NoticeDataSource

    init(remoteDataSource: NoticeDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func fetchNoticeList() -> Single<NoticeListEntity> {
        return remoteDataSource.fetchNoticeList()
            .map(NoticeListDTO.self)
            .map { $0.toDomain() }
    }
    
    func fetchDetailNotice(id: UUID) -> Single<DetailNoticeEntity> {
        return remoteDataSource.fetchDetailNotice(id: id)
            .map(DetailNoticeDTO.self)
            .map { $0.toDomain() }
    }
    
}
