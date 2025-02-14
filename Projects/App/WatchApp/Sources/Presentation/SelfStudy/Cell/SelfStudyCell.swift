import SwiftUI

import WatchDesignSystem

struct SelfStudyCell: View {
    @State private var floorText: Int
    @State private var teacher: String

    init(floorText: Int, teacher: String) {
        self.floorText = floorText
        self.teacher = teacher
    }

    var body: some View {
        HStack(spacing: 16) {
            Text("\(floorText)층")
                .font(.pickFont(.label2))
                .foregroundStyle(Color.main200)
            Text("\(teacher) 선생님")
                .font(.pickFont(.body1))
                .foregroundStyle(Color.modeWhite)
        }
        .background(Color.modeBlack)
    }

}

#Preview {
    SelfStudyCell(floorText: 2, teacher: "관리자")
}
