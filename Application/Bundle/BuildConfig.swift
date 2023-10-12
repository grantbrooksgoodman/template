//
//  BuildConfig.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

public enum BuildConfig {
    // MARK: - Flags

    public static let loggingEnabled = true
    public static let timebombActive = true

    // MARK: - Names

    public static let codeName = "Template"
    public static let finalName = ""

    // MARK: - Versioning

    public static let appStoreReleaseVersion = 0
    public static let dmyFirstCompileDateString = "29062007"
    public static let stage: Build.Stage = .preAlpha

    // MARK: - Other

    public static let languageCode = Locale.systemLanguageCode
    public static let loggerDomainSubscriptions: [LoggerDomain] = [.general]
}
