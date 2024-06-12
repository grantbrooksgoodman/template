//
//  MainQueueDependency.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import CoreArchitecture

public enum MainQueueDependency: DependencyKey {
    public static func resolve(_: DependencyValues) -> DispatchQueue {
        .main
    }
}

public extension DependencyValues {
    var mainQueue: DispatchQueue {
        get { self[MainQueueDependency.self] }
        set { self[MainQueueDependency.self] = newValue }
    }
}
