//
//  ThemeServiceDependency.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import Redux

public enum ThemeServiceDependency: DependencyKey {
    public static func resolve(_ dependencies: DependencyValues) -> ThemeService {
        ThemeService()
    }
}

public extension DependencyValues {
    var themeService: ThemeService {
        get {
            self[ThemeServiceDependency.self]
        }
        set {
            self[ThemeServiceDependency.self] = newValue
        }
    }
}
