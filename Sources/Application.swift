//
//  Application.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* Proprietary */
import AppSubsystem

/// The app's bootstrap configuration.
///
/// `Application` centralizes the two-step process required to
/// initialize the ``AppSubsystem`` framework: registering delegates and
/// calling ``AppSubsystem/initialize(appStoreBuildNumber:buildMilestone:codeName:finalName:languageCode:loggingEnabled:)``.
/// ``AppDelegate`` calls ``initialize()`` once at launch – no other
/// call site is needed.
///
/// To customize framework behavior, supply your own delegate
/// conformances in the
/// ``AppSubsystem/delegates/register(buildInfoOverlayDotIndicatorColorDelegate:cacheDomainListDelegate:devModeAppActionDelegate:exceptionMetadataDelegate:forcedUpdateModalDelegate:loggerDomainSubscriptionDelegate:permanentUserDefaultsKeyDelegate:uiThemeListDelegate:)``
/// call inside ``initialize()``. Pass `nil` for any delegate your
/// app does not need.
@MainActor
enum Application {
    /// Registers delegates and initializes the ``AppSubsystem``
    /// framework.
    ///
    /// This method performs two operations in sequence:
    ///
    /// 1. **Delegate registration.** Each delegate customizes a
    ///    specific aspect of ``AppSubsystem`` – caching policy,
    ///    developer-mode actions, exception metadata, localized
    ///    strings, logging, theming, and more. Delegates are defined
    ///    in the `Bundle` directory and conform to protocols declared
    ///    by ``AppSubsystem``.
    /// 2. **Framework initialization.** Configures build metadata
    ///    and enables all subsystem services. This call may only
    ///    occur once per launch; a second call triggers a fatal
    ///    error.
    ///
    /// Update the build metadata parameters – `appStoreBuildNumber`,
    /// `buildMilestone`, `codeName`, and `finalName` – to match
    /// your app's current release cycle.
    ///
    /// - Important: This method must be called exactly once, before
    ///   any other ``AppSubsystem`` API is used. ``AppDelegate``
    ///   calls it in
    ///   ``AppDelegate/application(_:didFinishLaunchingWithOptions:)``.
    static func initialize() {
        AppSubsystem.delegates.register(
            buildInfoOverlayDotIndicatorColorDelegate: nil,
            cacheDomainListDelegate: CacheDomain.List(),
            devModeAppActionDelegate: DevModeAction.AppActions(),
            exceptionMetadataDelegate: AppException.ExceptionMetadataDelegate(),
            forcedUpdateModalDelegate: nil,
            loggerDomainSubscriptionDelegate: LoggerDomain.SubscriptionDelegate(),
            permanentUserDefaultsKeyDelegate: UserDefaultsKey.PermanentKeyDelegate(),
            uiThemeListDelegate: UITheme.List()
        )

        AppSubsystem.initialize(
            appStoreBuildNumber: 0,
            buildMilestone: .preAlpha,
            codeName: "Template",
            finalName: "",
            languageCode: Locale.systemLanguageCode,
            loggingEnabled: true
        )
    }
}
