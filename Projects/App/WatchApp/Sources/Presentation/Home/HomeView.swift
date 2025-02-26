import SwiftUI
import UIKit

import WatchDesignSystem

struct HomeView: View {
    var body: some View {
        TabView {
            SchoolMealView()
            TimeTableView()
            SelfStudyView()

        }
        .tabViewStyle(.page)
    }
}

#Preview {
    HomeView()
}
