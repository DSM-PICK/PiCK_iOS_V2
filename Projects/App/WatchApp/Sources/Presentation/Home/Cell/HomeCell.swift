import SwiftUI
import WatchKit

import WatchDesignSystem

struct HomeCell: View {
    @State private var viewType: ViewType

    init(
        viewType: ViewType
    ) {
        self.viewType = viewType
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(viewType.rawValue)
                .font(.pickFont(.subTitle2))
                .foregroundStyle(Color.modeWhite)
                .padding(.horizontal, 12)
            ScrollView {
                LazyVStack(spacing: 8) {
                    switch viewType {
                    case .schoolMeal:
                        SchoolMealView()
                    case .timeTable:
                        TimeTableView()
                    case .selfStudy:
                        SelfStudyView()
                    }
                }
            }
        }
        .background(Color.modeBlack)
    }

}

#Preview {
    HomeView()
}
