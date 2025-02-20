import SwiftUI

import RxSwift

import WatchDesignSystem
import WatchAppNetwork

struct SelfStudyView: View {
    @StateObject var selfStudyViewModel: SelfStudyViewModel = SelfStudyViewModel()

    var body: some View {
        LazyVStack(
            alignment: .leading,
            spacing: 16
        ) {
            if let getPostData = selfStudyViewModel.selfStudyDTO {
                if getPostData.isEmpty {
                    Text("등록된 자습 감독\n선생님이 없습니다")
                        .font(.pickFont(.body1))
                        .foregroundStyle(Color.modeWhite)
                } else {
                    ForEach(getPostData, id: \.self) { data in
                        SelfStudyCell(
                            floorText: data.floor,
                            teacher: data.teacherName
                        )
                    }
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.top, 28)
        .onAppear {
            selfStudyViewModel.requestPost()
        }
    }

}

#Preview {
    HomeView()
}
