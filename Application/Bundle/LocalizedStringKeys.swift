//
//  LocalizedStringKeys.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

public enum LocalizedStringKey: String {
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
