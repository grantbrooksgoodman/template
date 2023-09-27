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
public enum TEException: String {
    /* Add new cases here. */

    case `default` = "0000"
}

/**
 Use this extension to add simplified descriptors commonly encountered errors.
 */
public extension Exception {
    // MARK: - Properties

    var userFacingDescriptor: String {
        @Dependency(\.build) var build: Build
        if let params = extraParams,
           let laymanDescriptor = params[Exception.CommonParamKeys.userFacingDescriptor.rawValue] as? String {
            return laymanDescriptor
        }

        switch descriptor {
        /* Add simplified error strings here. */
        default:
            return build.stage == .generalRelease ? Localized(.somethingWentWrong).wrappedValue : descriptor
        }
    }

    // MARK: - Methods

    func isEqual(to cataloggedException: TEException) -> Bool {
        hashlet == cataloggedException.rawValue
    }

    func isEqual(toAny in: [TEException]) -> Bool {
        !`in`.filter { $0.rawValue == hashlet }.isEmpty
    }
}
