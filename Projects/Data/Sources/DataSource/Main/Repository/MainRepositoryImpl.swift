//import Foundation
//
//import RxSwift
//
//import Domain
//
//class MainRepositoryImpl: MainRepository {
//    let remoteDataSource: MainDataSourceImpl
//
//    init(remoteDataSource: MainDataSourceImpl) {
//        self.remoteDataSource = remoteDataSource
//    }
//
//    func fetchMainData() -> Single<MainEntity?> {
//        return remoteDataSource.fetchMainData()
//            .map(MainDTO.self)
//            .map { $0.toDomain() }
//    }
//    
//}
