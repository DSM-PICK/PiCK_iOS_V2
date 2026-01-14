import SwiftUI
import WatchKit

import Kingfisher

import WatchDesignSystem

struct TimeTableCell: View {
    @State private var period: String
    @State private var subjectImage: String
    @State private var subject: String

    init(
        period: String,
        subjectImage: String,
        subject: String
    ) {
        self.period = period
        self.subjectImage = subjectImage
        self.subject = subject
    }

    var body: some View {
        LazyHStack {
            Text(period)
                .font(.pickFont(.label2))
                .foregroundStyle(Color.modeWhite)
            KFImage(URL(string: subjectImage))
                .setProcessor(DownsamplingImageProcessor(size: CGSize(width: 12 * WKInterfaceDevice.current().screenScale, height: 12 * WKInterfaceDevice.current().screenScale)))
                .scaleFactor(WKInterfaceDevice.current().screenScale)
                .cacheMemoryOnly()
                .fade(duration: 0.1)
                .resizable()
                .frame(width: 12, height: 12)
                .foregroundStyle(Color.main700)
            Text(subject)
                .font(.pickFont(.label2))
                .foregroundStyle(Color.modeWhite)
        }
        .background(Color.black)
    }

}

#Preview {
    TimeTableCell(period: "1교시", subjectImage: "", subject: "체육")
}
