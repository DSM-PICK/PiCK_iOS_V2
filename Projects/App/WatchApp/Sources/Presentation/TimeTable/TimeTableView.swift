import SwiftUI

import RxSwift
import RxCocoa

import Kingfisher

import WatchDesignSystem
import WatchAppNetwork

struct TimeTableView: View {
    @StateObject var postViewModel: TimeTableViewModel = TimeTableViewModel()

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 16) {
                if let getPostData = postViewModel.getPostData {
                    ForEach(getPostData, id: \.self) { data in
                        TimeTableCell(
                            period: "\(data?.period ?? 0)교시",
                            subjectImage: data?.image ?? "",
                            subject: data?.subjectName ?? ""
                        )
                    }
                }
            }
            .padding(.top, 16)
            .padding(.horizontal, 12)
            .onAppear {
                postViewModel.requestPost()
            }
        }
    }

}

#Preview {
    HomeCell(viewType: .timeTable)
}
