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
import AlertKit
import AppSubsystem
import Networking

public enum Application {
    @MainActor
    public static func initialize() {
        // MARK: - Dependencies

        @Dependency(\.alertKitConfig) var alertKitConfig: AlertKit.Config
        @Dependency(\.networking.hostedTranslation) var translator: HostedTranslationDelegate

        // MARK: - App Subsystem Setup

        AppSubsystem.delegates.register(
            appThemeListDelegate: AppTheme.List(),
            buildInfoOverlayDotIndicatorColorDelegate: Networking.BuildInfoOverlayDotIndicatorColorDelegate.shared,
            cacheDomainListDelegate: CacheDomain.List(),
            devModeAppActionDelegate: DevModeAction.AppActions(),
            exceptionMetadataDelegate: AppException.ExceptionMetadataDelegate(),
            localizedStringsDelegate: LocalizedStringKey.LocalizedStringsDelegate(),
            loggerDomainSubscriptionDelegate: LoggerDomain.SubscriptionDelegate(),
            permanentUserDefaultsKeyDelegate: UserDefaultsKey.PermanentKeyDelegate()
        )

        AppSubsystem.initialize(
            appStoreBuildNumber: 0,
            buildMilestone: .preAlpha,
            codeName: "Template",
            dmyFirstCompileDateString: "29062007",
            finalName: "",
            languageCode: Locale.systemLanguageCode,
            loggingEnabled: true
        )

        // MARK: - Networking Setup

        Networking.initialize()
        alertKitConfig.registerTranslationDelegate(translator)
    }
}
