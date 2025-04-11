import SwiftUI

import WatchDesignSystem

struct HomeView: View {
//    @State var isConnected: Bool = WatchSessionManager.shared.isReachable

    init() {
        WatchSessionManager.shared.activate()
    }

    var body: some View {
//        if isConnected {
//            Text("아이폰에서 먼저 로그인 후\n접속해주세요")
//                .font(.pickFont(.body1))
//                .foregroundStyle(Color.modeWhite)
//        } else {
            TabView {
                SchoolMealView()
                TimeTableView()
                SelfStudyView()
            }
            .tabViewStyle(.page)
//        }
    }
}

#Preview {
    HomeView()
}
