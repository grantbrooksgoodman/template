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
import AppSubsystem

/**
 Use this extension to catalog application-specific `Exception` types and their corresponding hashlet values.
 */
public extension AppException {
    // MARK: - Types

    struct ExceptionMetadataDelegate: AppSubsystem.Delegates.ExceptionMetadataDelegate {
        public func isReportable(_ hashlet: String) -> Bool { true }
        public func userFacingDescriptor(for descriptor: String) -> String? {
            switch descriptor {
            default: nil
            }
        }
    }

    // MARK: - Properties

    static let timedOut: AppException = .init("DE75")
}
