import SwiftUI

import WatchDesignSystem

struct SchoolMealView: View {
    @StateObject var postViewModel: SchoolMealViewModel = SchoolMealViewModel()

    var body: some View {
        ScrollView {
            LazyVStack(
                alignment: .leading,
                spacing: 8
            ) {
                if let getPostData = postViewModel.getPostData {
                    SchoolMealCell(
                        mealTimeIcon: .breakfastIcon,
                        menu: getPostData.breakfast.menu.joined(separator: "\n")
                    )
                    SchoolMealCell(
                        mealTimeIcon: .lunchIcon,
                        menu: getPostData.lunch.menu.joined(separator: "\n")
                    )
                    SchoolMealCell(
                        mealTimeIcon: .dinnerIcon,
                        menu: getPostData.dinner.menu.joined(separator: "\n")
                    )
                }
            }
            .padding(.horizontal, 12)
            .onAppear {
                postViewModel.requestPost()
            }
        }
    }

}

#Preview {
    HomeView()
}
