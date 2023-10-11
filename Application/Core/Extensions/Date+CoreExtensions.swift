//
//  Date+CoreExtensions.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import Redux

public extension Date {
    // MARK: - Properties

    var comparator: Date {
        @Dependency(\.currentCalendar) var calendar: Calendar
        return calendar.date(bySettingHour: 12, minute: 00, second: 00, of: calendar.startOfDay(for: self))!
    }

    var elapsedString: String {
        @Dependency(\.currentCalendar) var calendar: Calendar
        let interval = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self, to: Date())

        if let yearsPassed = interval.year,
           yearsPassed > 0 {
            return "\(yearsPassed)y"
        } else if let monthsPassed = interval.month,
                  monthsPassed > 0 {
            return "\(monthsPassed)mo"
        } else if let daysPassed = interval.day,
                  daysPassed > 0 {
            return "\(daysPassed)d"
        } else if let hoursPassed = interval.hour,
                  hoursPassed > 0 {
            return "\(hoursPassed)h"
        } else if let minutesPassed = interval.minute,
                  minutesPassed > 0 {
            return "\(minutesPassed)m"
        }

        return "now"
    }

    var formattedShortString: String {
        @Dependency(\.currentCalendar) var calendar: Calendar
        @Dependency(\.formattedShortStringDateFormatter) var dateFormatter: DateFormatter

        let currentDate = Date()
        let distance = currentDate.distance(to: self)

        if calendar.isDateInToday(self) {
            return DateFormatter.localizedString(from: self, dateStyle: .none, timeStyle: .short)
        } else if calendar.isDateInYesterday(self) {
            return Localized(.yesterday).wrappedValue
        } else if calendar.isDate(
            self,
            equalTo: currentDate,
            toGranularity: .weekOfYear
        ) || distance >= -604_800 {
            guard let weekdayString else { return dateFormatter.string(from: self) }
            return weekdayString
        }

        return dateFormatter.string(from: self)
    }

    var weekdayString: String? {
        @Dependency(\.currentCalendar) var calendar: Calendar
        switch calendar.component(.weekday, from: self) {
        case 1:
            return Localized(.sunday).wrappedValue
        case 2:
            return Localized(.monday).wrappedValue
        case 3:
            return Localized(.tuesday).wrappedValue
        case 4:
            return Localized(.wednesday).wrappedValue
        case 5:
            return Localized(.thursday).wrappedValue
        case 6:
            return Localized(.friday).wrappedValue
        case 7:
            return Localized(.saturday).wrappedValue
        default:
            return nil
        }
    }

    // MARK: - Methods

    func seconds(from date: Date) -> Int {
        @Dependency(\.currentCalendar) var calendar: Calendar
        return calendar.dateComponents([.second], from: date, to: self).second ?? 0
    }
}

/* MARK: Date Formatter Dependency */

// swiftlint:disable:next type_name
private enum FormattedShortStringDateFormatterDependency: DependencyKey {
    public static func resolve(_: DependencyValues) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = RuntimeStorage.languageCode == "en" ? .current : .init(identifier: RuntimeStorage.languageCode ?? Locale.current.identifier)
        formatter.dateStyle = .short
        return formatter
    }
}

private extension DependencyValues {
    var formattedShortStringDateFormatter: DateFormatter {
        get {
            self[FormattedShortStringDateFormatterDependency.self]
        }
        set {
            self[FormattedShortStringDateFormatterDependency.self] = newValue
        }
    }
}
