//
//  ObservableRegistryDependency.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import Redux

public enum ObservableRegistryDependency: DependencyKey {
    public static func resolve(_: DependencyValues) -> ObservableRegistry {
        .init()
    }
}

public extension DependencyValues {
    var observableRegistry: ObservableRegistry {
        get {
            self[ObservableRegistryDependency.self]
        }
        set {
            self[ObservableRegistryDependency.self] = newValue
        }
    }
}
