//
//  AKCoreDependency.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import AlertKit
import Redux

public enum AKCoreDependency: DependencyKey {
    public static func resolve(_: DependencyValues) -> AKCore {
        .shared
    }
}

public extension DependencyValues {
    var alertKitCore: AKCore {
        get { self[AKCoreDependency.self] }
        set { self[AKCoreDependency.self] = newValue }
    }
}
