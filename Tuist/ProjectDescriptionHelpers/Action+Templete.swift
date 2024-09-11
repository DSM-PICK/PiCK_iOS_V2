import ProjectDescription

public extension TargetScript {
    static let googleInfoPlistScripts = TargetScript.pre(
        script: """
                case "${CONFIGURATION}" in
                    "STAGE" )
                        cp -r "$SRCROOT/Resources/Firebase/GoogleService-Stage-Info.plist" "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/GoogleService-Info.plist" ;;
                    "PROD" )
                        cp -r "$SRCROOT/Resources/Firebase/GoogleService-Prod-Info.plist" "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/GoogleService-Info.plist" ;;
                    *)
                    ;;
                esac
                """,
        name: "GoogleService-Info.plist",
        basedOnDependencyAnalysis: false
    )
}
