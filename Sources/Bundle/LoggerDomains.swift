//
//  LoggerDomains.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* Proprietary */
import AppSubsystem

/// Use this extension to configure the app's logger domain
/// subscriptions.
///
/// Logger domains partition log output into named channels. Subscribe
/// to the domains you want to receive output from, and optionally
/// exclude specific domains from the on-disk session record.
///
/// To introduce a new domain for app-specific logging, define it as a
/// static property and add it to
/// ``SubscriptionDelegate/subscribedDomains``:
///
/// ```swift
/// extension LoggerDomain {
///     static let networking: LoggerDomain = .init("networking")
/// }
/// ```
extension LoggerDomain {
    /// The delegate that specifies which logger domains the app
    /// subscribes to at launch.
    struct SubscriptionDelegate: AppSubsystem.Delegates.LoggerDomainSubscriptionDelegate {
        /// The domains whose output is excluded from the on-disk
        /// session record.
        ///
        /// Messages logged to these domains still appear in the
        /// console, but are not written to the session record file.
        let domainsExcludedFromSessionRecord: [LoggerDomain] = [
            .observer,
        ]

        /// The domains the logger subscribes to at launch.
        ///
        /// Only messages logged to a subscribed domain produce output.
        /// Domains not listed here are silently ignored unless
        /// subscribed to at runtime.
        let subscribedDomains: [LoggerDomain] = [
            .alertKit,
            .caches,
            .concurrency,
            .general,
            .localization,
            .translation,
        ]
    }
}
