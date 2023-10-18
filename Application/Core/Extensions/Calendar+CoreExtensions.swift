//
//  Calendar+CoreExtensions.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import Redux

public extension Calendar {
    // MARK: - Types

    /// An enumeration for the localizable components of a calendar date.
    enum LocalizableComponent: CaseIterable {
        /* MARK: Cases */

        case day
        case hour
        case minute
        case month
        case second
        case week
        case year

        /* MARK: Properties */

        public var asComponent: Component {
            switch self {
            case .day:
                return .day
            case .hour:
                return .hour
            case .minute:
                return .minute
            case .month:
                return .month
            case .second:
                return .second
            case .week:
                return .weekOfMonth
            case .year:
                return .year
            }
        }

        public var asNSCalendarUnit: NSCalendar.Unit {
            switch self {
            case .day:
                return .day
            case .hour:
                return .hour
            case .minute:
                return .minute
            case .month:
                return .month
            case .second:
                return .second
            case .week:
                return .weekOfMonth
            case .year:
                return .year
            }
        }
    }

    // MARK: - Methods

    func localizedString(
        for component: LocalizableComponent,
        plural: Bool = false,
        style: DateComponentsFormatter.UnitsStyle = .full
    ) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.calendar = self
        formatter.allowedUnits = [component.asNSCalendarUnit]
        formatter.unitsStyle = style

        let currentDate = Date()
        guard let date = date(
            byAdding: .init(component),
            value: plural ? 2 : 1,
            to: currentDate
        ) else { return nil }
        let interval = date.timeIntervalSince(currentDate)
        guard let string = formatter.string(from: interval) else { return nil }
        return string.removingOccurrences(of: [plural ? "2" : "1"]).trimmingWhitespace
    }
}

public extension Calendar.Component {
    init(_ component: Calendar.LocalizableComponent) {
        switch component {
        case .day:
            self = .day
        case .hour:
            self = .hour
        case .minute:
            self = .minute
        case .month:
            self = .month
        case .second:
            self = .second
        case .week:
            self = .weekOfMonth
        case .year:
            self = .year
        }
    }
}
