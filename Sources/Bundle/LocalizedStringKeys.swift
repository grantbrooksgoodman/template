//
//  LocalizedStringKeys.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* Proprietary */
import AppSubsystem

public enum LocalizedStringKey: String, LocalizedStringKeyRepresentable {
    // MARK: - Cases

    /* Add cases here for newly pre-localized strings. */

    case cancel
    case copy

    case delete
    case dismiss
    case done

    case errorReportedSuccessfully

    case friday

    case internetConnectionOffline

    case monday

    case noEmail
    case noInternetMessage
    case noInternetTitle
    case noResults

    case reportBug
    case reportSent

    case saturday
    case search
    case sendFeedback
    case settings
    case somethingWentWrong
    case sunday

    case tapToReport
    case thursday
    case timedOut
    case today
    case tryAgain
    case tuesday

    case wednesday

    case yesterday

    // MARK: - Properties

    public var referent: String { rawValue.snakeCased }
}

public extension Localized where T == LocalizedStringKey {
    init(
        _ key: LocalizedStringKey,
        languageCode: String = RuntimeStorage.languageCode
    ) {
        self.init(key: key, languageCode: languageCode)
    }
}

public extension LocalizedStringKey {
    struct LocalizedStringsDelegate: AppSubsystem.Delegates.LocalizedStringsDelegate {
        public var cancel: String { Localized(.cancel).wrappedValue }
        public var done: String { Localized(.done).wrappedValue }
        public var dismiss: String { Localized(.dismiss).wrappedValue }
        public var internetConnectionOffline: String { Localized(.internetConnectionOffline).wrappedValue }
        public var noEmail: String { Localized(.noEmail).wrappedValue }
        public var noInternetMessage: String { Localized(.noInternetMessage).wrappedValue }
        public var reportBug: String { Localized(.reportBug).wrappedValue }
        public var reportSent: String { Localized(.reportSent).wrappedValue }
        public var sendFeedback: String { Localized(.sendFeedback).wrappedValue }
        public var settings: String { Localized(.settings).wrappedValue }
        public var somethingWentWrong: String { Localized(.somethingWentWrong).wrappedValue }
        public var tapToReport: String { Localized(.tapToReport).wrappedValue }
        public var timedOut: String { Localized(.timedOut).wrappedValue }
        public var tryAgain: String { Localized(.tryAgain).wrappedValue }
        public var yesterday: String { Localized(.yesterday).wrappedValue }
    }
}
