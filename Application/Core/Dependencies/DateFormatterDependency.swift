//
//  DateFormatterDependency.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import Redux

public enum ISO8601BritishDateAndTimeFormatterDependency: DependencyKey {
    public static func resolve(_ dependencies: DependencyValues) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
        formatter.locale = .init(identifier: "en_GB")
        return formatter
    }
}

public extension DependencyValues {
    var britishDateAndTimeFormatter: DateFormatter {
        get {
            self[ISO8601BritishDateAndTimeFormatterDependency.self]
        }
        set {
            self[ISO8601BritishDateAndTimeFormatterDependency.self] = newValue
        }
    }
}
