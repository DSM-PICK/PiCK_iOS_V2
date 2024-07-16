import Foundation

import RxSwift

import Domain

class NoticeRepositoryImpl: NoticeRepository {
    
    let remoteDataSource = NoticeDataSource.shared
     
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
