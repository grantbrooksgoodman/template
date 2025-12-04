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

enum LocalizedStringKey: String, LocalizedStringKeyRepresentable {
    // MARK: - Cases

    /* Add cases here for newly pre-localized strings. */

    case cancel
    case copy

    case delete
    case dismiss
    case done

    case errorReported
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

    var referent: String { rawValue.snakeCased }
}

extension Localized where T == LocalizedStringKey {
    init(
        _ key: LocalizedStringKey,
        languageCode: String = RuntimeStorage.languageCode
    ) {
        self.init(key: key, languageCode: languageCode)
    }
}

extension LocalizedStringKey {
    struct LocalizedStringsDelegate: AppSubsystem.Delegates.LocalizedStringsDelegate {
        var cancel: String { Localized(.cancel).wrappedValue }
        var done: String { Localized(.done).wrappedValue }
        var dismiss: String { Localized(.dismiss).wrappedValue }
        var errorReported: String { Localized(.errorReported).wrappedValue }
        var internetConnectionOffline: String { Localized(.internetConnectionOffline).wrappedValue }
        var noEmail: String { Localized(.noEmail).wrappedValue }
        var noInternetMessage: String { Localized(.noInternetMessage).wrappedValue }
        var reportBug: String { Localized(.reportBug).wrappedValue }
        var reportSent: String { Localized(.reportSent).wrappedValue }
        var sendFeedback: String { Localized(.sendFeedback).wrappedValue }
        var settings: String { Localized(.settings).wrappedValue }
        var somethingWentWrong: String { Localized(.somethingWentWrong).wrappedValue }
        var tapToReport: String { Localized(.tapToReport).wrappedValue }
        var timedOut: String { Localized(.timedOut).wrappedValue }
        var tryAgain: String { Localized(.tryAgain).wrappedValue }
        var yesterday: String { Localized(.yesterday).wrappedValue }
    }
}
