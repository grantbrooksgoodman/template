//
//  Observables.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* Proprietary */
import AppSubsystem

/// Use this extension to declare app-specific ``Observable`` values
/// for cross-scope communication.
///
/// Define each observable as a static property. Use a typed observable
/// to share a changing value, or `Observable<Nil>` to broadcast an
/// event with no payload:
///
/// ```swift
/// extension Observables {
///     static let isLoggedIn = Observable<Bool>(false)
///     static let sessionDidExpire = Observable<Nil>()
/// }
/// ```
///
/// Write to a typed observable's ``Observable/value`` property to
/// update it and notify all registered observers. For event-style
/// observables, call ``Observable/trigger()`` instead:
///
///     Observables.isLoggedIn.value = true
///     Observables.sessionDidExpire.trigger()
///
/// - SeeAlso: ``Observer``
extension Observables {}
