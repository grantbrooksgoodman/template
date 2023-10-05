//
//  ExceptionCatalog.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import Redux

/**
 Use this enum to catalog application-specific ``Exception`` types and their corresponding hashlet values.
 */
public enum AppException: String {
    /* Add new cases here. */

    case timedOut = "DE75"
}

/**
 Use this extension to add simplified descriptors for commonly encountered errors.
 */
public extension Exception {
    // MARK: - Properties

    var userFacingDescriptor: String {
        @Dependency(\.build) var build: Build
        if let params = extraParams,
           let laymanDescriptor = params[Exception.CommonParamKeys.userFacingDescriptor.rawValue] as? String {
            return laymanDescriptor
        }

        switch hashlet {
        /* Add simplified error strings here. */
        default:
            return build.stage == .generalRelease ? Localized(.somethingWentWrong).wrappedValue : descriptor
        }
    }

    // MARK: - Methods

    func isEqual(to cataloggedException: AppException) -> Bool {
        hashlet == cataloggedException.rawValue
    }

    func isEqual(toAny in: [AppException]) -> Bool {
        !`in`.filter { $0.rawValue == hashlet }.isEmpty
    }
}
