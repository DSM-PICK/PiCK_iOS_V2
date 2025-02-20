import SwiftUI

import RxSwift
import RxCocoa

import Kingfisher

import WatchDesignSystem
import WatchAppNetwork

struct TimeTableView: View {
    @StateObject var timeTableViewModel: TimeTableViewModel = TimeTableViewModel()

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 16) {
                if let timeTableData = timeTableViewModel.timeTableDTO {
                    if timeTableData.isEmpty {
                        Text("등록된 시간표가 없습니다")
                            .font(.pickFont(.body1))
                            .foregroundStyle(Color.modeWhite)
                            .padding(.top, 12)
                    } else {
                        ForEach(
                            timeTableData, id: \.self
                        ) { data in
                            TimeTableCell(
                                period: "\(data?.period ?? 0)교시",
                                subjectImage: data?.image ?? "",
                                subject: data?.subjectName ?? ""
                            )
                        }
                    }
                }
            }
            .padding(.top, 16)
            .padding(.horizontal, 12)
            .onAppear {
                timeTableViewModel.requestPost()
            }
        }
    }

}

#Preview {
    HomeView()
}
