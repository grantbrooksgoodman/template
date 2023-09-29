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
        @Dependency(\.userDefaults) var defaults: UserDefaults
        typealias Config = BuildConfig

        var developerModeEnabled = false
        if let defaultsValue = defaults.value(forKey: .core(.developerModeEnabled)) as? Bool {
            developerModeEnabled = Config.stage == .generalRelease ? false : defaultsValue
            defaults.set(developerModeEnabled, forKey: .core(.developerModeEnabled))
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
