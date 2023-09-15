//
//  ExceptionCatalog.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/**
 Use this enum to catalog application-specific ``Exception`` types and their corresponding hashlet values.
 */
public enum TEException {
    /* MARK: Cases */

    /* MARK: Properties */

    public var description: String {
        switch self {
        /* Add hashlet values here. */
        default:
            return .init()
        }
    }
}

/**
 Use this extension to add simplified error descriptors and create ``Exception`` builders for commonly encountered errors.
 */
public extension Exception {
    /* MARK: Properties */

    var userFacingDescriptor: String {
        if let params = extraParams,
           let laymanDescriptor = params["UserFacingDescriptor"] as? String {
            return laymanDescriptor
        }

        switch descriptor {
        /* Add simplified error strings here. */
        default:
            return Build.stage == .generalRelease ? "Something went wrong, please try again later." : descriptor
        }
    }

    /* MARK: Methods */

    func isEqual(to cataloggedException: TEException) -> Bool {
        hashlet == cataloggedException.description
    }

    func isEqual(toAny in: [TEException]) -> Bool {
        !`in`.filter { $0.description == hashlet }.isEmpty
    }
}
