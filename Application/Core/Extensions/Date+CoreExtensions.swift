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

    func elapsedString() -> String {
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

    func formattedShortString() -> String {
        let differenceBetweenDates = Date().comparator.distance(to: comparator)

        let stylizedDateFormatter = DateFormatter()
        stylizedDateFormatter.locale = RuntimeStorage.languageCode == "en" ? .current : Locale(identifier: RuntimeStorage.languageCode!)
        stylizedDateFormatter.dateStyle = .short

        if differenceBetweenDates == 0 {
            return DateFormatter.localizedString(from: self, dateStyle: .none, timeStyle: .short)
        } else if differenceBetweenDates == -86400 {
            return Localized(.yesterday).wrappedValue
        } else if differenceBetweenDates >= -604_800 {
            guard let weekdayString,
                  weekdayString == Date().weekdayString else {
                return stylizedDateFormatter.string(from: self)
            }

            return weekdayString
        }

        return stylizedDateFormatter.string(from: self)
    }

    func seconds(from date: Date) -> Int {
        @Dependency(\.currentCalendar) var calendar: Calendar
        return calendar.dateComponents([.second], from: date, to: self).second ?? 0
    }
}
