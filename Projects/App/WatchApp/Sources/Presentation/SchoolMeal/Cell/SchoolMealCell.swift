import SwiftUI

import WatchDesignSystem

struct SchoolMealCell: View {
    @State private var mealTimeIcon: Image
    @State private var menu: String

    init(
        mealTimeIcon: Image,
        menu: String?
    ) {
        self.mealTimeIcon = mealTimeIcon
        self.menu = menu ?? "급식이 없습니다"
    }

    var body: some View {
        LazyVStack {
            mealTimeIcon
                .foregroundStyle(Color.main200)
            Text(menu)
                .font(.pickFont(.body2))
                .foregroundStyle(Color.modeWhite)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 12)
        .background(Color.modeBlack)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.main200, lineWidth: 1)
        )
    }
}

#Preview {
    SchoolMealCell(mealTimeIcon: .breakfastIcon, menu: "국밥")
}
