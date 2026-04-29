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

/// Use this extension to catalog application-specific error codes and
/// configure how exceptions are reported.
///
/// Define known error codes as static ``AppException`` properties so
/// that error-handling logic can match exceptions by code:
///
/// ```swift
/// extension AppException {
///     static let unauthorized: AppException = .init("C31B")
/// }
///
/// if exception.isEqual(to: .unauthorized) {
///     presentSignIn()
/// }
/// ```
///
/// Customize ``ExceptionMetadataDelegate`` to control which errors
/// are reportable and to supply user-facing descriptions for known
/// error conditions.
extension AppException {
    // MARK: - Types

    /// The delegate that provides app-specific metadata for exception
    /// handling.
    ///
    /// Modify ``isReportable(_:)`` to suppress reporting for specific
    /// error codes, and ``userFacingDescriptor(for:)`` to provide
    /// human-readable descriptions for known error conditions.
    struct ExceptionMetadataDelegate: AppSubsystem.Delegates.ExceptionMetadataDelegate {
        /// Returns a Boolean value indicating whether the exception
        /// with the given error code should be reported.
        ///
        /// The default implementation returns `true` for all error
        /// codes. Add cases to a `switch` statement to return `false`
        /// for codes that should not generate reports.
        ///
        /// - Parameter errorCode: The exception's error code.
        ///
        /// - Returns: `true` if the exception can be reported;
        ///   otherwise, `false`.
        func isReportable(_ errorCode: String) -> Bool { true }

        /// Returns a user-facing description for the given
        /// developer-facing descriptor, or `nil` if no mapping exists.
        ///
        /// Implement this method to translate internal error
        /// descriptors into messages appropriate for the user. Return
        /// `nil` to use the subsystem's default error message.
        ///
        /// - Parameter descriptor: The exception's developer-facing
        ///   descriptor.
        ///
        /// - Returns: A user-appropriate string, or `nil`.
        func userFacingDescriptor(for descriptor: String) -> String? {
            switch descriptor {
            default: nil
            }
        }
    }

    // MARK: - Properties

    /// An exception representing a timed-out operation.
    static let timedOut: AppException = .init("801F")
}
