//
//  RootWindowServiceDependency.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import Redux

public enum RootWindowServiceDependency: DependencyKey {
    public static func resolve(_: DependencyValues) -> RootWindowService {
        .init()
    }
}

public extension DependencyValues {
    var rootWindowService: RootWindowService {
        get { self[RootWindowServiceDependency.self] }
        set { self[RootWindowServiceDependency.self] = newValue }
    }
}
