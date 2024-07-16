//import Foundation
//
//import RxSwift
//
//import Domain
//
//class MainRepositoryImpl: MainRepository {
//    
//    let remoteDataSource = MainDataSource.shared
//    
//    func fetchMainData() -> Single<MainEntity?> {
//        return remoteDataSource.fetchMainData()
//            .map(MainDTO.self)
//            .map { $0.toDomain() }
//    }
//    
//}
