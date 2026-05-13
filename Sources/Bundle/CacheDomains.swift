//
//  CacheDomains.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* Proprietary */
import AppSubsystem

/// Use this extension to register application-specific cache domains.
///
/// Add ``CacheDomain`` values to the ``List/appCacheDomains`` array
/// so they are included alongside the subsystem's built-in domains.
/// Registered domains are cleared during memory-pressure cleanup.
///
/// ```swift
/// extension CacheDomain {
///     static let avatars: CacheDomain = .init("avatars") {
///         AvatarCache.shared.clear()
///     }
/// }
/// ```
///
/// Then add the new domain to ``List/appCacheDomains``:
///
/// ```swift
/// let appCacheDomains: [CacheDomain] = [.avatars]
/// ```
extension CacheDomain {
    /// The delegate that supplies the app's cache domains to the
    /// subsystem.
    ///
    /// The subsystem merges these domains with its own built-in
    /// domains automatically.
    struct List: AppSubsystem.Delegates.CacheDomainListDelegate {
        /// The cache domains defined by this app.
        let appCacheDomains: [CacheDomain] = []
    }
}
