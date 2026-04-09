//
//  ExceptionCatalog.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* Proprietary */
// TODO: Remove when using Swift 6 branch.
@preconcurrency import AppSubsystem

/**
 Use this extension to catalog application-specific `Exception` types and their corresponding error code values.
 */
extension AppException {
    // MARK: - Types

    struct ExceptionMetadataDelegate: AppSubsystem.Delegates.ExceptionMetadataDelegate {
        func isReportable(_ errorCode: String) -> Bool { true }
        func userFacingDescriptor(for descriptor: String) -> String? {
            switch descriptor {
            default: nil
            }
        }
    }

    // MARK: - Properties

    static let timedOut: AppException = .init("801F")
}
