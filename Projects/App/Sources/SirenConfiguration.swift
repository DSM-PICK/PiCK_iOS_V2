import Siren

public class SirenConfiguration {
    public static func setup() {
        let siren = Siren.shared
        
        siren.apiManager = APIManager(country: .korea) // 기준 위치 대한민국 앱스토어
        
        Siren.shared.presentationManager = PresentationManager (
//            appName: "appname",
            alertTitle: "PiCK 업데이트 알림",
            alertMessage: "원활한 서비스 이용을 위해 \n최신 버전으로 업데이트해 주세요.",
            updateButtonTitle: "업데이트",
            forceLanguageLocalization: .korean
        )
         Siren.shared.rulesManager = RulesManager(globalRules: .critical)
    }

    public static func check() {
        Siren.shared.wail()
    }
}
