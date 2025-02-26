import SwiftUI

import RxSwift

import WatchDesignSystem
import WatchAppNetwork

struct SelfStudyView: View {
    @StateObject var selfStudyViewModel: SelfStudyViewModel = SelfStudyViewModel()

    var body: some View {
        ScrollView {
            LazyVStack(
                alignment: .leading,
                spacing: 16
            ) {
                Text("자습감독 선생님")
                    .font(.pickFont(.subTitle2))
                    .foregroundStyle(Color.modeWhite)
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
            .onAppear {
                selfStudyViewModel.requestPost()
            }
        }
    }

}

#Preview {
    HomeView()
}
