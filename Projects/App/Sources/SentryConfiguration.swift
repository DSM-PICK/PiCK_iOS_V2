import Sentry

import Core

public class SentryConfiguration {
    // PROD 구성이고 DSN 이 정상적으로 들어있을 때만 Sentry 를 초기화함
    public static func setup() {
        guard AppEnvironment.isProd,
              let dsn = AppEnvironment.sentryDSN
        else { return }

        SentrySDK.start { options in
            options.dsn = dsn
            options.environment = "production"
            options.releaseName = "\(AppEnvironment.bundleID)@\(AppEnvironment.appVersion)+\(AppEnvironment.buildNumber)"
            options.sendDefaultPii = false
            options.tracesSampleRate = 0.2
        }
    }
}
