//
//  TimestampDateFormatterDependency.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import CoreArchitecture

public enum TimestampDateFormatterDependency: DependencyKey {
    public static func resolve(_: DependencyValues) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
        formatter.locale = .init(identifier: "en_US")
        return formatter
    }
}

public extension DependencyValues {
    var timestampDateFormatter: DateFormatter {
        get { self[TimestampDateFormatterDependency.self] }
        set { self[TimestampDateFormatterDependency.self] = newValue }
    }
}
