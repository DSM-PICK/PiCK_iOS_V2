//import Foundation
//
//import Core
//
//import Starscream
//
//open class WebSocketManager: WebSocketDelegate {
//    private let message = KeychainImpl().load(type: .id)
//
//    public var statusData
//    public init() {}
//    public func didReceive(
//        event: Starscream.WebSocketEvent,
//        client: any Starscream.WebSocketClient
//    ) {
//        switch event {
//        case .connected(let headers):
//            client.write(string: message)
//            print("websocket is connected: \(headers)")
//
//        case .disconnected(let reason, let code):
//            print("websocket is disconnected: \(reason) with code: \(code)")
//
//        case .text(let text):
////            let jsonString = text
////            let messageData = convertJSONStringToStruct(jsonString: jsonString, data: Teststruct.self)
////                setOutingStatus(data: messageData as! Teststruct)
////                print("Message type: \(messageData)")
//
//            print(text)
//        case .cancelled:
//            print("websocket is canclled")
//
//        case .error(let error):
//            print("websocket is error = \(error!)")
//
//        default:
//            break
//
//        }
//    }
//    public func convertJSONStringToStruct<T: Decodable>(jsonString: String, data: T.Type) -> Any? {
//        guard let jsonData = jsonString.data(using: .utf8) else {
//            print("Error: Cannot convert string to Data")
//            return nil
//        }
//
//        let decoder = JSONDecoder()
//
//        do {
//            let messageData = try decoder.decode(T.self, from: jsonData)
//            return messageData
//        } catch {
//            print("Error decoding JSON: \(error)")
//            return nil
//        }
//    }
//}
