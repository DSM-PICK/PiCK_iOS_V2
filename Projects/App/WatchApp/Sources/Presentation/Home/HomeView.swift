import SwiftUI
import UIKit

import WatchDesignSystem

enum ViewType: String {
    case schoolMeal = "급식"
    case timeTable = "시간표"
    case selfStudy = "자습감독 선생님"
}

struct HomeView: View {
    @State private var currentStep = 0

    var body: some View {
        GeometryReader { geo in
            TabView(
                selection: $currentStep.animation()
            ) {
                HomeCell(viewType: .schoolMeal)
                HomeCell(viewType: .timeTable)
                HomeCell(viewType: .selfStudy)
            }
            .tabViewStyle(.page)
        }
    }

}

#Preview {
    HomeView()
}
