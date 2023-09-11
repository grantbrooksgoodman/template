//
//  RegistryDependency.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import Redux

public enum RegistryDependency: DependencyKey {
    public static func resolve(_ dependencies: DependencyValues) -> Registry {
        Registry()
    }
}

public extension DependencyValues {
    var registry: Registry {
        get {
            self[RegistryDependency.self]
        }
        set {
            self[RegistryDependency.self] = newValue
        }
    }
}
