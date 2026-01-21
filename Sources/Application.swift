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

enum Application {
    static func initialize() {
        AppSubsystem.delegates.register(
            buildInfoOverlayDotIndicatorColorDelegate: nil,
            cacheDomainListDelegate: CacheDomain.List(),
            devModeAppActionDelegate: DevModeAction.AppActions(),
            exceptionMetadataDelegate: AppException.ExceptionMetadataDelegate(),
            forcedUpdateModalDelegate: nil,
            localizedStringsDelegate: LocalizedStringKey.LocalizedStringsDelegate(),
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
