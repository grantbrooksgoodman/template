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

public enum Application {
    public static func initialize() {
        // MARK: - App Subsystem Setup

        AppSubsystem.delegates.register(
            appThemeListDelegate: AppTheme.List(),
            buildInfoOverlayDotIndicatorColorDelegate: nil,
            cacheDomainListDelegate: CacheDomain.List(),
            devModeAppActionDelegate: DevModeAction.AppActions(),
            exceptionMetadataDelegate: AppException.ExceptionMetadataDelegate(),
            localizedStringsDelegate: Localization.LocalizedStringsDelegate()
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

        // MARK: - Localization & Logging Setup

        Localization.initialize()

        Logger.setDomainsExcludedFromSessionRecord(LoggerDomain.domainsExcludedFromSessionRecord)
        Logger.subscribe(to: LoggerDomain.subscribedDomains)
    }
}
