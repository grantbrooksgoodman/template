//
//  CalendarDependencies.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import Redux

public enum CurrentCalendarDependency: DependencyKey {
    public static func resolve(_: DependencyValues) -> Calendar {
        .current
    }
}

public enum SystemLocalizedCalendarDependency: DependencyKey {
    public static func resolve(_: DependencyValues) -> Calendar {
        var calendar: Calendar = .current
        calendar.locale = .init(languageCode: .init(RuntimeStorage.languageCode))
        return calendar
    }
}

public extension DependencyValues {
    var currentCalendar: Calendar {
        get { self[CurrentCalendarDependency.self] }
        set { self[CurrentCalendarDependency.self] = newValue }
    }

    var systemLocalizedCalendar: Calendar {
        get { self[SystemLocalizedCalendarDependency.self] }
        set { self[SystemLocalizedCalendarDependency.self] = newValue }
    }
}
