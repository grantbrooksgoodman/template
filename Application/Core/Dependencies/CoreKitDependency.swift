//
//  CoreKitDependency.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import Redux

public enum CoreKitDependency: DependencyKey {
    public static func resolve(_ dependencies: DependencyValues) -> CoreKit {
        .init(gcd: .init(),
              hud: .init(),
              ui: .init(),
              utils: .init())
    }
}

public extension DependencyValues {
    var coreKit: CoreKit {
        get {
            self[CoreKitDependency.self]
        }
        set {
            self[CoreKitDependency.self] = newValue
        }
    }
}
