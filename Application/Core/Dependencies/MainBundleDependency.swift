//
//  MainBundleDependency.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import Redux

public enum MainBundleDependency: DependencyKey {
    public static func resolve(_: DependencyValues) -> Bundle {
        .main
    }
}

public extension DependencyValues {
    var mainBundle: Bundle {
        get { self[MainBundleDependency.self] }
        set { self[MainBundleDependency.self] = newValue }
    }
}
