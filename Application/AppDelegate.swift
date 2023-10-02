//
//  AppDelegate.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import UIKit

/* 3rd-party */
import AlertKit
import Redux

@main
public class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: - UIApplication

    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        preInitialize()

        /* Encapsulate further work here into setup functions. */

        return true
    }

    public func applicationDidBecomeActive(_ application: UIApplication) {}

    // MARK: - Initialization + Setup

    private func preInitialize() {
        /* MARK: Dependencies */

        @Dependency(\.alertKitCore) var akCore: AKCore
        @Dependency(\.breadcrumbs) var breadcrumbs: Breadcrumbs
        @Dependency(\.build) var build: Build
        @Dependency(\.userDefaults) var defaults: UserDefaults

        /* MARK: Defaults Keys & Logging Setup */

        RuntimeStorage.store(BuildConfig.languageCode, as: .core(.languageCode))
        Logger.subscribe(to: BuildConfig.loggerDomainSubscriptions)

        if build.stage == .generalRelease {
            defaults.set(false, forKey: .core(.breadcrumbsCaptureEnabled))
            defaults.removeObject(forKey: .core(.breadcrumbsCapturesAllViews))
        } else if let breadcrumbsCaptureEnabled = defaults.value(forKey: .core(.breadcrumbsCaptureEnabled)) as? Bool,
                  let breadcrumbsCapturesAllViews = defaults.value(forKey: .core(.breadcrumbsCapturesAllViews)) as? Bool,
                  breadcrumbsCaptureEnabled {
            breadcrumbs.startCapture(uniqueViewsOnly: !breadcrumbsCapturesAllViews)
        }

        if defaults.value(forKey: .core(.hidesBuildInfoOverlay)) as? Bool == nil {
            defaults.set(false, forKey: .core(.hidesBuildInfoOverlay))
        }

        /* MARK: Developer Mode Setup */

        DevModeService.addStandardActions()
        DevModeService.addCustomActions()

        /* MARK: Theme Setup */

        if let themeName = defaults.value(forKey: .core(.pendingThemeName)) as? String,
           let correspondingCase = AppTheme.allCases.first(where: { $0.theme.name == themeName }) {
            ThemeService.setTheme(correspondingCase.theme, checkStyle: false)
            defaults.removeObject(forKey: .core(.pendingThemeName))
        } else if let themeName = defaults.value(forKey: .core(.currentTheme)) as? String,
                  let correspondingCase = AppTheme.allCases.first(where: { $0.theme.name == themeName }) {
            ThemeService.setTheme(correspondingCase.theme, checkStyle: false)
        } else {
            defaults.set(AppTheme.default.theme.name, forKey: .core(.currentTheme))
            ThemeService.setTheme(AppTheme.default.theme, checkStyle: false)
        }

        /* MARK: AlertKit Setup */

        let connectionAlertDelegate = ConnectionAlertDelegate()
        let expiryAlertDelegate = ExpiryAlertDelegate()
        let reportDelegate = ReportDelegate()
        let translationDelegate = TranslationDelegate()

        akCore.setLanguageCode(RuntimeStorage.languageCode!)
        akCore.register(
            connectionAlertDelegate: connectionAlertDelegate,
            expiryAlertDelegate: expiryAlertDelegate,
            reportDelegate: reportDelegate,
            translationDelegate: translationDelegate
        )

        /* MARK: Localization Setup */

        let localizedStrings = Localization.localizedStrings
        guard !localizedStrings.isEmpty else {
            Logger.log(.init("Missing localized strings.", metadata: [self, #file, #function, #line]))
            return
        }

        let unsupportedLanguageCodes = ["ba", "ceb", "jv", "la", "mr", "ms", "udm"]
        let supportedLanguages = localizedStrings["language_codes"]?.filter { !unsupportedLanguageCodes.contains($0.key) }
        guard let supportedLanguages else {
            Logger.log(.init("No supported languages.", metadata: [self, #file, #function, #line]))
            return
        }

        RuntimeStorage.store(supportedLanguages, as: .core(.languageCodeDictionary))
        guard let languageCodeDictionary = RuntimeStorage.languageCodeDictionary else { return }

        guard languageCodeDictionary[RuntimeStorage.languageCode!] != nil else {
            RuntimeStorage.store("en", as: .core(.languageCode))
            akCore.setLanguageCode("en")

            Logger.log(
                .init(
                    "Unsupported language code; reverting to English.",
                    metadata: [self, #file, #function, #line]
                )
            )
            return
        }
    }

    // MARK: - UISceneSession

    public func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    public func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
