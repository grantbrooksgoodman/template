//
//  CalendarDependency.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import Redux

public enum CalendarDependency: DependencyKey {
    public static func resolve(_ dependencies: DependencyValues) -> Calendar {
        Calendar.current
    }
}

public extension DependencyValues {
    var currentCalendar: Calendar {
        get {
            self[CalendarDependency.self]
        }
        set {
            self[CalendarDependency.self] = newValue
        }
    }
}
