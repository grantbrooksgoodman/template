//
//  NotificationCenterDependency.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import Redux

public enum NotificationCenterDependency: DependencyKey {
    public static func resolve(_: DependencyValues) -> NotificationCenter {
        .default
    }
}

public extension DependencyValues {
    var notificationCenter: NotificationCenter {
        get {
            self[NotificationCenterDependency.self]
        }
        set {
            self[NotificationCenterDependency.self] = newValue
        }
    }
}
