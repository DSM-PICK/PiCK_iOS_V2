import SwiftUI

import WatchDesignSystem

struct SchoolMealView: View {
    @StateObject var schoolMealViewModel: SchoolMealViewModel = SchoolMealViewModel()

    var body: some View {
        ScrollView {
            LazyVStack(
                alignment: .leading,
                spacing: 8
            ) {
                let schoolMealData = schoolMealViewModel.schoolMealDTO
                if schoolMealData == nil {
                        Text("등록된 급식이 없습니다")
                            .font(.pickFont(.body1))
                            .foregroundStyle(Color.modeWhite)
                            .padding(.top, 28)
                    } else {
                        SchoolMealCell(
                            mealTimeIcon: .breakfastIcon,
                            menu: schoolMealData?.breakfast.menu.joined(separator: "\n")
                        )
                        SchoolMealCell(
                            mealTimeIcon: .lunchIcon,
                            menu: schoolMealData?.lunch.menu.joined(separator: "\n")
                        )
                        SchoolMealCell(
                            mealTimeIcon: .dinnerIcon,
                            menu: schoolMealData?.dinner.menu.joined(separator: "\n")
                        )
                    }
            }
            .padding(.horizontal, 12)
            .onAppear {
                schoolMealViewModel.requestPost()
            }
        }
    }

}

#Preview {
    HomeView()
}
