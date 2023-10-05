//
//  BuildDependency.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import Redux

public enum BuildDependency: DependencyKey {
    public static func resolve(_: DependencyValues) -> Build {
        typealias Config = BuildConfig

        var developerModeEnabled = false
        @Persistent(.core(.developerModeEnabled)) var defaultsValue: Bool?
        if let value = defaultsValue {
            developerModeEnabled = Config.stage == .generalRelease ? false : value
            defaultsValue = developerModeEnabled
        }

        return .init(
            appStoreReleaseVersion: Config.appStoreReleaseVersion,
            codeName: Config.codeName,
            developerModeEnabled: developerModeEnabled,
            dmyFirstCompileDateString: Config.dmyFirstCompileDateString,
            finalName: Config.finalName,
            loggingEnabled: Config.loggingEnabled,
            stage: Config.stage,
            timebombActive: Config.timebombActive
        )
    }
}

public extension DependencyValues {
    var build: Build {
        get {
            self[BuildDependency.self]
        }
        set {
            self[BuildDependency.self] = newValue
        }
    }
}
