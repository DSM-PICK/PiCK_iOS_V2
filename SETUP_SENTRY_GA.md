# Sentry + Google Analytics(Firebase) 연동 가이드

Sentry 와 GA 는 **PROD 구성에서만** 동작합니다. STAGE 빌드에서는 Sentry 를 초기화하지 않고, GA 수집도 꺼져 있습니다.
(`FirebaseApp.configure()` 는 푸시 알림(FCM) 때문에 STAGE 에서도 그대로 실행됩니다. Analytics 수집만 꺼집니다.)

---

## 1. 빌드 전에 받아야 하는 비밀 파일

비밀 파일은 레포에 커밋하지 않습니다. 모두 `.gitignore` 에 들어 있습니다.

| 파일 | 받는 곳 | 넣을 위치 |
|---|---|---|
| `XCConfig/` 폴더 전체 | 비공개 레포 `DSM-PICK/PiCK_iOS_V2_XCConfig` 의 `XCConfig/` | 레포 루트의 `XCConfig/` |
| `GoogleService-Stage-Info.plist` | 비공개 레포 `DSM-PICK/PiCK-iOS-GoogleInfo` 의 `FireBase/` | `Projects/App/Resources/Firebase/` |
| `GoogleService-Prod-Info.plist` | 위와 같음 | `Projects/App/Resources/Firebase/` |
| Sentry DSN | Sentry 프로젝트 → Settings → Client Keys (DSN) | `XCConfig/PiCK-iOS-v2/PROD.xcconfig` (아래 2번 참고) |

`ci_scripts/ci_post_clone.sh` 가 하는 것과 같은 작업입니다.

```bash
git clone https://github.com/DSM-PICK/PiCK_iOS_V2_XCConfig.git /tmp/xcconfig && mv /tmp/xcconfig/XCConfig ./XCConfig
```

```bash
git clone https://github.com/DSM-PICK/PiCK-iOS-GoogleInfo.git /tmp/googleinfo && mkdir -p Projects/App/Resources/Firebase && cp /tmp/googleinfo/FireBase/* Projects/App/Resources/Firebase/
```

---

## 2. xcconfig 에 추가할 줄

`XCConfig/PiCK-iOS-v2/PROD.xcconfig` 에 아래 한 줄을 추가합니다. 이 파일은 비공개 XCConfig 레포에도 반영해 주세요.

- 폴더 이름은 소문자 `v` 인 `PiCK-iOS-v2` 입니다. 앱 타깃 이름은 `PiCK-iOS-V2` 인데, macOS 파일 시스템이 대소문자를 구분하지 않아서 그대로 찾아집니다. 파일을 열 때 헷갈리지 않도록 실제 이름을 적었습니다.

```
SENTRY_DSN = https:/$()/<PUBLIC_KEY>@<ORG_HOST>.ingest.sentry.io/<PROJECT_ID>
```

- **`//` 를 그대로 쓰면 안 됩니다.** xcconfig 에서 `//` 는 주석으로 처리되기 때문에, `https://...` 라고 쓰면 값이 `https:` 에서 잘립니다. `$()` 는 빈 값으로 치환되는 변수라서 `https:/$()/` 가 빌드 후 `https://` 가 됩니다.
- `STAGE.xcconfig` 에는 추가하지 않습니다. 넣더라도 코드에서 PROD 가 아니면 Sentry 를 시작하지 않습니다.
- DSN 이 없거나 형식이 잘못돼도 앱은 죽지 않습니다. Sentry 초기화만 건너뜁니다 (`AppEnvironment.sentryDSN` 이 `nil`).

---

## 3. 빌드 순서 (Mac)

1. Tuist 4.31.0 을 설치합니다. 레포의 `.mise.toml` 에 버전이 고정돼 있습니다.
   ```bash
   mise install tuist@4.31.0
   ```
2. 1번의 비밀 파일과 2번의 `SENTRY_DSN` 을 넣습니다.
3. 의존성 설치와 프로젝트 생성 (`make generate` 와 같습니다).
   ```bash
   tuist install
   ```
   ```bash
   tuist generate
   ```
   - `tuist install` 단계에서 sentry-cocoa 9.32.0 을 내려받고 `Tuist/Package.resolved` 가 바뀝니다. **바뀐 `Tuist/Package.resolved` 는 이 브랜치에 커밋해 주세요.** (Windows 에서 작업해 이 파일은 갱신하지 못했습니다.)
4. 생성된 `PiCK-iOS-V2.xcworkspace` 를 엽니다.
5. 스킴을 `PiCK-iOS-V2-PROD` 로 고르고 실기기에서 실행합니다. STAGE 동작 확인은 `PiCK-iOS-V2-STAGE` 로 합니다.
   - Xcode 16 이상이 필요합니다 (Sentry 9.x 요구사항).

빌드가 막히면 먼저 아래를 시도해 보세요.
```bash
make regenerate
```

---

## 4. 연동 확인 방법

### 4-1. Sentry 테스트 에러 보내기

1. 확인할 때만 `Projects/App/Sources/SentryConfiguration.swift` 의 `SentrySDK.start` 안에 `options.debug = true` 를 잠깐 추가합니다. 콘솔에 Sentry 로그가 찍힙니다.
2. 같은 파일의 `SentrySDK.start { ... }` 바로 아래에 테스트 코드를 잠깐 넣습니다.
   ```swift
   SentrySDK.capture(message: "Sentry 연동 테스트")
   ```
3. `PiCK-iOS-V2-PROD` 스킴으로 실행합니다. Sentry 웹 → Issues 에서 `environment:production` 으로 필터해 메시지가 왔는지 봅니다.
4. 크래시 리포트도 보고 싶다면 `SentrySDK.crash()` 를 호출합니다. 주의할 점이 두 가지 있습니다.
   - **Xcode 디버거가 붙어 있으면 크래시가 잡히지 않습니다.** Xcode 에서 실행한 뒤 Stop 을 누르고, 홈 화면에서 앱을 직접 실행한 상태에서 크래시를 냅니다.
   - 크래시 리포트는 **앱을 다시 실행할 때** 전송됩니다.
5. 확인이 끝나면 `options.debug = true` 와 테스트 코드를 지웁니다.

STAGE 스킴으로 같은 테스트를 했을 때 Sentry 에 아무것도 오지 않으면 정상입니다.

### 4-2. Firebase DebugView 로 이벤트 확인하기

1. Xcode → Product → Scheme → Edit Scheme → Run → Arguments → **Arguments Passed On Launch** 에 `-FIRDebugEnabled` 를 추가합니다.
2. `PiCK-iOS-V2-PROD` 스킴으로 실기기에서 실행합니다.
3. 추적 허용 팝업(ATT)이 뜨면 **"허용"** 을 누릅니다. 거부하면 수집이 꺼집니다. 이미 거부했다면 설정 → 개인정보 보호 및 보안 → 추적에서 PiCK 을 켭니다.
4. Firebase 콘솔 → Analytics → **DebugView** 에서 기기를 선택하고 아래 이벤트를 확인합니다.

| 이벤트 | 발생 시점 | 파라미터 |
|---|---|---|
| `screen_view` | 화면 진입 | `screen_name` (예: `Home`, `OutingApply`), `screen_class` |
| `login` | 로그인 성공 | `method=id_password` |
| `apply_submit` | 외출/조기귀가/교실이동/주말급식 신청 | `apply_type`, `result` (`success` / `fail`) |
| `apply_cancel` | 주말급식 신청 취소 | `apply_type=weekend_meal`, `result` |
| `pass_view` | 홈에서 외출증/조기귀가증 열람 | `pass_type` (`outing` / `early_leave`) |
| `notice_open` | 공지 상세 열람 | 없음 |
| `bug_report_submit` | 버그 제보 | `result` |

5. 확인이 끝나면 `-FIRDebugEnabled` 를 지우거나 체크를 끕니다.

새 이벤트를 추가할 때는 `Projects/Core/Sources/Util/Analytics/AnalyticsEvent.swift` 에 case 를 추가하고, 호출하는 곳에서 `AnalyticsService.log(.새이벤트)` 를 부르면 됩니다.

---

## 5. dSYM 업로드 (Sentry 크래시 심볼리케이션)

dSYM 이 없으면 Sentry 크래시 스택이 주소로만 보입니다. **auth token 은 코드나 레포에 넣지 않습니다.**

1. Sentry → Settings → Auth Tokens 에서 `project:releases` 권한이 있는 토큰을 만듭니다 (Organization Token 권장).
2. 방법 A: 아카이브 후 수동 업로드
   ```bash
   brew install getsentry/tools/sentry-cli
   ```
   ```bash
   SENTRY_AUTH_TOKEN=<TOKEN> sentry-cli debug-files upload --org <ORG_SLUG> --project <PROJECT_SLUG> --include-sources <Archive 안의 dSYMs 폴더 경로>
   ```
   - Archive 위치: Xcode → Organizer → 아카이브 우클릭 → Show in Finder → `.xcarchive` 패키지 내용 보기 → `dSYMs/`
3. 방법 B: Xcode Cloud 에서 자동 업로드
   - Xcode Cloud 워크플로 환경 변수에 `SENTRY_AUTH_TOKEN` 을 **Secret** 으로 등록합니다.
   - `ci_scripts/ci_post_xcodebuild.sh` 를 만들고, `$CI_ARCHIVE_PATH/dSYMs` 를 위 명령으로 업로드합니다.
   - 이 스크립트는 이번 작업에 포함하지 않았습니다. 필요하면 별도로 추가해 주세요.
4. PROD(Release) 구성의 `DEBUG_INFORMATION_FORMAT` 은 `dwarf-with-dsym` 이어야 합니다. Tuist `.recommended` 기본값이 Release 에서 이 값을 씁니다.

---

## 6. 이번 작업에서 바뀐 동작

- **FirebaseCrashlytics 를 제거했습니다.** Sentry 와 Crashlytics 는 둘 다 크래시 시그널 핸들러를 가로채서 하나만 정상 동작합니다. 코드에서 Crashlytics 를 쓰는 곳은 없었습니다.
- Firebase 자동 화면 추적(`FirebaseAutomaticScreenReportingEnabled`)을 껐습니다. 대신 `BaseViewController` / `BaseReactorViewController` 에서 `screen_view` 를 직접 보냅니다. 중복 수집과 UIKit 컨테이너 화면 수집을 막기 위해서입니다.
- Info.plist 에 `FIREBASE_ANALYTICS_COLLECTION_ENABLED = false` 를 넣었습니다. 다만 Firebase 는 `setAnalyticsCollectionEnabled` 값을 앱 재실행 후에도 유지하고, 그 값이 plist 보다 우선합니다. 그래서 다음처럼 처리합니다.
  - 앱 시작 시 `FirebaseApp.configure()` **전에** 현재 ATT 권한을 읽어 수집 상태를 즉시 덮어씁니다 (`AnalyticsConfiguration.applyCurrentTrackingStatus()`). 예전에 허용했다가 설정에서 철회한 사용자도 첫 이벤트부터 수집되지 않습니다.
  - 포그라운드로 돌아올 때(`sceneWillEnterForeground`)도 같은 처리를 합니다.
  - **PROD + ATT 허용**일 때만 수집을 켭니다.
- 수집이 꺼져 있는 동안 보인 화면은 기억해 두었다가, 수집이 켜지는 순간 `screen_view` 로 한 번 기록합니다. 새로 설치한 경우 ATT 팝업에 응답하기 전에 첫 화면이 지나가도 그 화면이 빠지지 않습니다.
- 주말급식은 같은 API 로 신청과 취소를 모두 처리합니다. 신청은 `apply_submit`, 취소는 `apply_cancel` 로 나눠 기록합니다.
- ATT 콜백의 `@unknown default: fatalError` 를 없앴습니다. 이제 `authorized` 가 아닌 상태는 모두 수집 꺼짐으로 처리합니다.

---

## 7. 빌드할 때 특히 봐야 할 곳 (Windows 에서 작성해 빌드로 확인하지 못한 부분)

1. **`tuist install` 에서 sentry-cocoa 9.32.0 을 내려받는지.** `Sentry` 제품은 미리 빌드된 정적 xcframework 입니다. Tuist 가 정적 프레임워크인 `ThirdPartyLib` 에 붙여 앱까지 링크하는지 확인해 주세요. 링크 오류가 나면 `Tuist/Package.swift` 의 `productTypes` 에 `"Sentry": .staticFramework` 를 추가해 보세요.
2. **앱 타깃에서 `import Sentry` 가 되는지** (`SentryConfiguration.swift`). Firebase 를 앱 타깃에서 import 하는 것과 같은 경로(ThirdPartyLib 경유)를 기대하고 있습니다.
3. **Sentry 9.x 옵션 이름.** `releaseName`, `environment`, `sendDefaultPii`, `tracesSampleRate` 가 컴파일되는지 확인해 주세요. 공식 문서 기준으로 작성했습니다.
4. **Crashlytics 제거 후 빌드.** 남은 `FirebaseCrashlytics` 참조나 dSYM 관련 Run Script 오류가 없는지 확인해 주세요.
5. **`APP_CONFIGURATION`** 이 실제로 `PROD` / `STAGE` 로 들어가는지. 빌드된 앱의 Info.plist 를 열거나, 디버거에서 `AppEnvironment.configuration` 을 출력해 확인해 주세요.
6. **RxSwift 에 넣은 `.do(onCompleted:)` / `.do(onSuccess:)` 타입 추론.** 특히 `WeekendMealApplyViewModel` 은 `.catch` 클로저를 여러 줄로 바꿨습니다.
7. **`screen_view` 화면 이름.** 탭 전환과 push 할 때 DebugView 에 의도한 이름(`Home`, `Apply` 등)으로 찍히는지 확인해 주세요.
8. SwiftLint 경고가 새로 생기지 않았는지.
9. **`FirebaseApp.configure()` 전에 `Analytics.setAnalyticsCollectionEnabled` 를 부르는 부분** (`AppDelegate`). 공식 문서에 순서 제약은 없지만, 콘솔에 "Firebase not configured" 같은 오류가 찍히거나 값이 적용되지 않으면 `AnalyticsConfiguration.applyCurrentTrackingStatus()` 를 `FirebaseApp.configure()` 바로 다음 줄로 옮겨 주세요.
10. **권한 철회 시나리오.** PROD 에서 추적 허용 → 설정에서 PiCK 추적 끄기 → 앱 복귀/재실행 했을 때 DebugView 에 이벤트가 더 이상 오지 않는지.
11. **새 설치 시나리오.** 앱 삭제 → 재설치 → ATT 팝업 전에 첫 화면 표시 → "허용" 했을 때 DebugView 에 첫 화면의 `screen_view` 가 한 번 찍히는지.
