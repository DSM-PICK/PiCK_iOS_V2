import SwiftUI
import UIKit

import WatchDesignSystem

enum ViewType: String {
    case schoolMeal = "급식"
    case timeTable = "시간표"
    case selfStudy = "자습감독 선생님"
}

struct HomeView: View {
    var body: some View {
        TabView {
            HomeCell(viewType: .schoolMeal)
            HomeCell(viewType: .timeTable)
            HomeCell(viewType: .selfStudy)
        }
        .tabViewStyle(.page)
    }
}

#Preview {
    HomeView()
}
