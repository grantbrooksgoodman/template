//
//  LocaleDependency.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import Redux

public enum LocaleDependency: DependencyKey {
    public static func resolve(_: DependencyValues) -> Locale {
        .current
    }
}

public extension DependencyValues {
    var currentLocale: Locale {
        get { self[LocaleDependency.self] }
        set { self[LocaleDependency.self] = newValue }
    }
}
