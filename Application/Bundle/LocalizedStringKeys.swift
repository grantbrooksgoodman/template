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
    /* MARK: Cases */

    /* Add cases here for newly pre-localized strings. */

    case cancel
    case copy

    case delete
    case dismiss
    case done

    case noEmail
    case noInternetMessage
    case noInternetTitle

    case reportBug
    case timedOut
    case tryAgain

    case search
    case sendFeedback
    case settings

    case sunday
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday

    case today
    case yesterday

    /* MARK: Properties */

    public var description: String {
        return rawValue.snakeCased
    }
}
