//
//  AlertKitConfigDependency.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import AlertKit
import CoreArchitecture

public enum AlertKitConfigDependency: DependencyKey {
    public static func resolve(_: DependencyValues) -> AlertKit.Config {
        .shared
    }
}

public extension DependencyValues {
    var alertKitConfig: AlertKit.Config {
        get { self[AlertKitConfigDependency.self] }
        set { self[AlertKitConfigDependency.self] = newValue }
    }
}
