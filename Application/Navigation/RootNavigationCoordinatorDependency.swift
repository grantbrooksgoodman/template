//
//  RootNavigationCoordinatorDependency.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import Redux

public enum RootNavigationCoordinatorDependency: DependencyKey {
    public static func resolve(_: DependencyValues) -> RootNavigationCoordinator {
        .init()
    }
}

public extension DependencyValues {
    var rootNavigationCoordinator: RootNavigationCoordinator {
        get { self[RootNavigationCoordinatorDependency.self] }
        set { self[RootNavigationCoordinatorDependency.self] = newValue }
    }
}
