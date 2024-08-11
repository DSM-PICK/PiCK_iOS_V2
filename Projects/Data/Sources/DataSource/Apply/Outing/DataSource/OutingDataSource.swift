//import Foundation
//
//import RxSwift
//import Moya
//import RxMoya
//
//import AppNetwork
//import Domain
//
//protocol OutingDataSource {
//    func outingApply(reason: String, startTime: String, endTime: String) -> Completable
//    func fetchOutingPass() -> Single<Response>
//    func earlyLeaveApply(reason: String, startTime: String) -> Completable
//    func fetchEarlyLeavePass() -> Single<Response>
//}
//
//class OutingDataSourceImpl: BaseDataSource<OutingAPI>, OutingDataSource {
//    func outingApply(reason: String, startTime: String, endTime: String) -> Completable {
//        return provider.rx.request(.outingApply(
//            reason: reason,
//            startTime: startTime,
//            endTime: endTime
//        ))
//        .asCompletable()
//    }
//    func fetchOutingPass() -> Single<Response> {
//        return provider.rx.request(.fetchOutingPass)
//            .filterSuccessfulStatusCodes()
//    }
//    func earlyLeaveApply(reason: String, startTime: String) -> Completable {
//        return provider.rx.request(.earlyLeaveApply(
//            reason: reason,
//            startTime: startTime
//        ))
//        .asCompletable()
//    }
//    func fetchEarlyLeavePass() -> Single<Response> {
//        return provider.rx.request(.fetchEarlyLeavePass)
//            .filterSuccessfulStatusCodes()
//    }
//    
//}
