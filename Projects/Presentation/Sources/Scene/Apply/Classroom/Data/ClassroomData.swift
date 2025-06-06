import Foundation

public class ClassroomData {
    public init() { }
    static let shared = ClassroomData()

    let firstFloor = [
        "산학협력부", "새롬홀", "무한 상상실",
        "청죽관", "AI 연구실", "탁구실", "운동장", "밴드부실"
    ]

    let secondFloor = [
        "3-1", "3-2", "3-3", "3-4", "세미나실 2-1",
        "세미나실 2-2", "세미나실 2-3", "세미나실 2-4", "SW 1실", "SW 2실",
        "SW 3실", "본부 교무실", "제3 교무실", "카페테리아",
        "창조실", "방송실", "진로 상담실", "여자 헬스장"
    ]

    let thirdFloor = [
        "2-1", "2-2", "2-3", "2-4", "세미나실 3-1",
        "세미나실 3-2", "세미나실 3-3", "보안 1실",
        "보안 2실", "제2 교무실", "그린존", "남자 헬스장"
    ]

    let fourthFloor = [
        "1-1", "1-2", "1-3", "1-4", "세미나실 4-1",
        "세미나실 4-2", "세미나실 4-3", "세미나실 4-4",
        "임베 1실", "임베 2실", "제1 교무실"
    ]

    let fifthFloor = [
        "음악실", "음악 준비실", "상담실",
        "수학실", "과학실"
    ]

    public var allFloors: [[String]] {
        return [
            firstFloor,
            secondFloor,
            thirdFloor,
            fourthFloor,
            fifthFloor
        ]
    }
}
