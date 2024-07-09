//
//  AppDelegate.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import UIKit

/* 3rd-party */
import AlertKit
import CoreArchitecture
import Translator

@main
public final class AppDelegate: UIResponder, UIApplicationDelegate {
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

        @Dependency(\.alertKitConfig) var alertKitConfig: AlertKit.Config
        @Dependency(\.breadcrumbs) var breadcrumbs: Breadcrumbs
        @Dependency(\.build) var build: Build
        @Dependency(\.coreKit) var core: CoreKit
        @Dependency(\.reportDelegate) var reportDelegate: ReportDelegate
        @Dependency(\.translationService) var translator: TranslationService

        /* MARK: Defaults Keys & Logging Setup */

        RuntimeStorage.store(BuildConfig.languageCode, as: .languageCode)

        Logger.setDomainsExcludedFromSessionRecord(BuildConfig.loggerDomainsExcludedFromSessionRecord)
        Logger.subscribe(to: BuildConfig.loggerDomainSubscriptions)
        translator.registerTranslationLoggerDelegate(Logger.TranslationLogger())

        @Persistent(.breadcrumbsCaptureEnabled) var breadcrumbsCaptureEnabled: Bool?
        @Persistent(.breadcrumbsCapturesAllViews) var breadcrumbsCapturesAllViews: Bool?
        if build.stage == .generalRelease {
            breadcrumbsCaptureEnabled = false
            breadcrumbsCapturesAllViews = nil
        } else if let breadcrumbsCaptureEnabled,
                  let breadcrumbsCapturesAllViews,
                  breadcrumbsCaptureEnabled {
            breadcrumbs.startCapture(uniqueViewsOnly: !breadcrumbsCapturesAllViews)
        }

        @Persistent(.hidesBuildInfoOverlay) var hidesBuildInfoOverlay: Bool?
        if hidesBuildInfoOverlay == nil {
            hidesBuildInfoOverlay = false
        }

        /* MARK: Developer Mode Setup */

        DevModeService.addStandardActions()
        DevModeService.addCustomActions()

        /* MARK: Theme Setup */

        @Persistent(.pendingThemeID) var pendingThemeID: String?
        @Persistent(.currentThemeID) var currentThemeID: String?

        if let themeID = pendingThemeID,
           let correspondingCase = AppTheme.allCases.first(where: { $0.theme.encodedHash == themeID }) {
            ThemeService.setTheme(correspondingCase.theme, checkStyle: false)
            pendingThemeID = nil
        } else if let currentThemeID,
                  let correspondingCase = AppTheme.allCases.first(where: { $0.theme.encodedHash == currentThemeID }) {
            ThemeService.setTheme(correspondingCase.theme, checkStyle: false)
        } else {
            ThemeService.setTheme(AppTheme.default.theme, checkStyle: false)
        }

        /* MARK: AlertKit Setup */

        alertKitConfig.overrideTargetLanguageCode(RuntimeStorage.languageCode)
        alertKitConfig.overrideTranslationHUDConfig(.init(appearsAfter: .milliseconds(500), isModal: true))

        alertKitConfig.registerLoggerDelegate(Logger.AlertKitLogger())
        alertKitConfig.registerPresentationDelegate(core)
        alertKitConfig.registerReportDelegate(reportDelegate)
        alertKitConfig.registerTranslationDelegate(TranslationDelegate())

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

        RuntimeStorage.store(supportedLanguages, as: .languageCodeDictionary)
        guard let languageCodeDictionary = RuntimeStorage.languageCodeDictionary else { return }

        guard languageCodeDictionary[RuntimeStorage.languageCode] != nil else {
            RuntimeStorage.store("en", as: .languageCode)
            alertKitConfig.overrideTargetLanguageCode("en")

            Logger.log(
                .init(
                    "Unsupported language code; reverting to English.",
                    metadata: [self, #file, #function, #line]
                )
            )
            return
        }

        /* MARK: Navigation Setup */

        let navigationCoordinator: NavigationCoordinator<RootNavigationService> = .init(
            .init(modal: .splash),
            navigating: RootNavigationService()
        )

        NavigationCoordinatorResolver.shared.store(navigationCoordinator)
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
