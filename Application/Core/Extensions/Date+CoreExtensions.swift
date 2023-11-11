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
    // MARK: - Types

    enum WeekdaySymbolLength {
        case full
        case short
        case veryShort
    }

    // MARK: - Properties

    var comparator: Date {
        @Dependency(\.currentCalendar) var calendar: Calendar
        return calendar.date(bySettingHour: 12, minute: 00, second: 00, of: calendar.startOfDay(for: self))!
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
            return weekdayString()
        }

        return dateFormatter.string(from: self)
    }

    // MARK: - Methods

    func elapsedString(
        style: DateComponentsFormatter.UnitsStyle = .abbreviated,
        granularity: [Calendar.LocalizableComponent] = Calendar.LocalizableComponent.allCases
    ) -> String? {
        @Dependency(\.systemLocalizedCalendar) var calendar: Calendar

        let currentDate = Date()
        guard currentDate > self else { return nil }

        let components = granularity.map(\.asComponent)
        let dateComponents = calendar.dateComponents(Set(components), from: self, to: currentDate)

        var elapsedMap = DateComponents()
        for component in components {
            guard let value = dateComponents.value(for: component),
                  value > 0 else { continue }
            elapsedMap.setValue(value, for: component)
        }

        func string(_ component: Calendar.LocalizableComponent) -> String? {
            calendar.localizedString(for: component, plural: true, style: style)
        }

        if let years = elapsedMap.year,
           let component = string(.year) {
            return "\(years) \(component)"
        } else if let months = elapsedMap.month,
                  let component = string(.month) {
            return "\(months) \(component)"
        } else if let weeks = elapsedMap.weekOfMonth,
                  let component = string(.week) {
            return "\(weeks) \(component)"
        } else if let days = elapsedMap.day,
                  let component = string(.day) {
            return "\(days) \(component)"
        } else if let hours = elapsedMap.hour,
                  let component = string(.hour) {
            return "\(hours) \(component)"
        } else if let minutes = elapsedMap.minute,
                  let component = string(.minute) {
            return "\(minutes) \(component)"
        } else if let seconds = elapsedMap.second,
                  let component = string(.second) {
            return "\(seconds) \(component)"
        }

        return nil
    }

    func seconds(from date: Date) -> Int {
        @Dependency(\.currentCalendar) var calendar: Calendar
        return calendar.dateComponents([.second], from: date, to: self).second ?? 0
    }

    func weekdayString(
        _ length: WeekdaySymbolLength = .full,
        standalone: Bool = false
    ) -> String {
        @Dependency(\.systemLocalizedCalendar) var calendar: Calendar
        var symbols: [String]
        switch length {
        case .full:
            symbols = standalone ? calendar.standaloneWeekdaySymbols : calendar.weekdaySymbols
        case .short:
            symbols = standalone ? calendar.shortStandaloneWeekdaySymbols : calendar.shortWeekdaySymbols
        case .veryShort:
            symbols = standalone ? calendar.veryShortStandaloneWeekdaySymbols : calendar.veryShortWeekdaySymbols
        }

        let dayPosition = calendar.component(.weekday, from: self) - 1
        guard dayPosition > 0,
              symbols.count > dayPosition else { return .init() }
        return symbols[dayPosition]
    }
}

/* MARK: DateFormatter Dependency */

// swiftlint:disable:next type_name
private enum FormattedShortStringDateFormatterDependency: DependencyKey {
    public static func resolve(_: DependencyValues) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = RuntimeStorage.languageCode == "en" ? .current : .init(languageCode: .init(RuntimeStorage.languageCode))
        formatter.dateStyle = .short
        return formatter
    }
}

private extension DependencyValues {
    var formattedShortStringDateFormatter: DateFormatter {
        get { self[FormattedShortStringDateFormatterDependency.self] }
        set { self[FormattedShortStringDateFormatterDependency.self] = newValue }
    }
}
