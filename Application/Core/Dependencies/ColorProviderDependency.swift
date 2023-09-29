//
//  ColorProviderDependency.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import Redux

public enum ColorProviderDependency: DependencyKey {
    public static func resolve(_: DependencyValues) -> ColorProvider {
        .init()
    }
}

public extension DependencyValues {
    var colorProvider: ColorProvider {
        get {
            self[ColorProviderDependency.self]
        }
        set {
            self[ColorProviderDependency.self] = newValue
        }
    }
}
