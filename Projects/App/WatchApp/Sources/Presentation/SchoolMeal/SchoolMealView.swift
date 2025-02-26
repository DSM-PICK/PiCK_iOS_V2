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
                Text("급식")
                    .font(.pickFont(.subTitle2))
                    .foregroundStyle(Color.modeWhite)
                let schoolMealData = schoolMealViewModel.schoolMealDTO
                if schoolMealData == nil {
                    VStack(alignment: .center) {
                        Text("아이폰에서 먼저 로그인 후\n접속해주세요")
                            .font(.pickFont(.body1))
                            .foregroundStyle(Color.modeWhite)
                    }
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
