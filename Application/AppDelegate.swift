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
    
    // MARK: - Dependencies
    
    @Dependency(\.alertKitCore) private var akCore: AKCore
    @Dependency(\.breadcrumbs) private var breadcrumbs: Breadcrumbs
    @Dependency(\.userDefaults) private var defaults: UserDefaults
    
    // MARK: - UIApplication
    
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        preInitialize()
        
        /* Encapsulate further work here into setup functions. */
        
        return true
    }
    
    public func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    // MARK: - Initialization + Setup
    
    private func preInitialize() {
        /* MARK: Build & Logger Setup */
        
        RuntimeStorage.store(BuildConfig.languageCode, as: .languageCode)
        
        var developerModeEnabled = false
        if let developerMode = defaults.value(forKey: .developerModeEnabled) as? Bool {
            developerModeEnabled = Build.stage == .generalRelease ? false : developerMode
        }
        
        Build.set([.appStoreReleaseVersion: BuildConfig.appStoreReleaseVersion,
                   .codeName: BuildConfig.codeName,
                   .developerModeEnabled: developerModeEnabled,
                   .dmyFirstCompileDateString: BuildConfig.dmyFirstCompileDateString,
                   .finalName: BuildConfig.finalName,
                   .loggingEnabled: BuildConfig.loggingEnabled,
                   .stage: BuildConfig.stage,
                   .timebombActive: BuildConfig.timebombActive])
        
        defaults.set(developerModeEnabled, forKey: .developerModeEnabled)
        Logger.subscribe(to: BuildConfig.loggerDomainSubscriptions)
        
        if Build.stage == .generalRelease {
            defaults.set(false, forKey: .breadcrumbsCaptureEnabled)
            defaults.removeObject(forKey: .breadcrumbsCapturesAllViews)
        } else if let breadcrumbsCaptureEnabled = defaults.value(forKey: .breadcrumbsCaptureEnabled) as? Bool,
                  let breadcrumbsCapturesAllViews = defaults.value(forKey: .breadcrumbsCapturesAllViews) as? Bool,
                  breadcrumbsCaptureEnabled {
            breadcrumbs.startCapture(uniqueViewsOnly: !breadcrumbsCapturesAllViews)
        }
        
        DevModeService.addStandardActions()
        DevModeService.addCustomActions()
        
        if defaults.value(forKey: .hidesBuildInfoOverlay) as? Bool == nil {
            defaults.set(false, forKey: .hidesBuildInfoOverlay)
        }
        
        /* MARK: Theme Setup */
        
        if let themeName = defaults.value(forKey: .pendingThemeName) as? String,
           let correspondingTheme = AppTheme.allCases.first(where: { $0.theme.name == themeName }) {
            ThemeService.setTheme(correspondingTheme.theme, checkStyle: false)
            defaults.removeObject(forKey: .pendingThemeName)
        } else if let themeName = defaults.value(forKey: .currentTheme) as? String,
                  let correspondingCase = AppTheme.allCases.first(where: { $0.theme.name == themeName }) {
            ThemeService.setTheme(correspondingCase.theme, checkStyle: false)
        } else {
            defaults.set(AppTheme.default.theme.name, forKey: .currentTheme)
            ThemeService.setTheme(AppTheme.default.theme, checkStyle: false)
        }
        
        /* MARK: AlertKit Setup */
        
        let connectionAlertDelegate = ConnectionAlertDelegate()
        let expiryAlertDelegate = ExpiryAlertDelegate()
        let reportDelegate = ReportDelegate()
        
        akCore.setLanguageCode(RuntimeStorage.languageCode!)
        akCore.register(connectionAlertDelegate: connectionAlertDelegate,
                        expiryAlertDelegate: expiryAlertDelegate,
                        reportDelegate: reportDelegate)
        
        /* MARK: Localization Setup */
        
        guard let filePath = Bundle.main.url(forResource: "LocalizedStrings", withExtension: "plist"),
              let data = try? Data(contentsOf: filePath),
              let localizedStrings = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: [String: String]] else {
            Logger.log("Missing localized strings.",
                       with: .fatalAlert,
                       metadata: [#file, #function, #line])
            return
        }
        
        let unsupportedLanguageCodes = ["ba", "ceb", "jv", "la", "mr", "ms", "udm"]
        let supportedLanguages = localizedStrings["language_codes"]?.filter({ !unsupportedLanguageCodes.contains($0.key) })
        guard let supportedLanguages else {
            Logger.log(.init("No supported languages.", metadata: [#file, #function, #line]))
            return
        }
        
        RuntimeStorage.store(supportedLanguages, as: .languageCodeDictionary)
        guard let languageCodeDictionary = RuntimeStorage.languageCodeDictionary else { return }
        
        guard languageCodeDictionary[RuntimeStorage.languageCode!] != nil else {
            RuntimeStorage.store("en", as: .languageCode)
            akCore.setLanguageCode("en")
            
            Logger.log("Unsupported language code; reverting to English.",
                       metadata: [#file, #function, #line])
            return
        }
    }
    
    // MARK: - UISceneSession
    
    public func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
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
