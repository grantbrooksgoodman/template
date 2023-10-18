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
 Use this enum to catalog application-specific `Exception` types and their corresponding hashlet values.
 */
public enum AppException: String {
    /* Add new cases here. */

    case timedOut = "DE75"
}

/**
 Use this method to add simplified descriptors for commonly encountered errors.
 */
public extension Exception {
    func userFacingDescriptor(for descriptor: String) -> String? {
        switch descriptor {
        /* Add simplified error descriptors here. */
        default:
            return nil
        }
    }
}
