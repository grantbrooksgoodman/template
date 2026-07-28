//
//  Shared.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

// swiftformat:disable emptyExtensions

/* Native */
import Foundation

/* Proprietary */
import AppSubsystem

/// Use this extension to declare app-specific ``SharedState`` and
/// ``SharedEvent`` values for cross-scope communication.
///
/// Define each shared value as a static property. Use ``SharedState``
/// to share a changing value, or ``SharedEvent`` to broadcast events;
/// `SharedEvent<Void>` suits signals that carry no payload:
///
/// ```swift
/// extension Shared {
///     static let isLoggedIn = SharedState<Bool>(false)
///     static let sessionDidExpire = SharedEvent<Void>()
/// }
/// ```
///
/// Write to a `SharedState` through its ``SharedState/value`` property,
/// and send events with ``SharedEvent/send(_:)``:
///
///     Shared.isLoggedIn.value = true
///     Shared.sessionDidExpire.send()
///
/// Subscribe view models with ``ViewModelOf/observing(_:_:)``, or
/// iterate the ``SharedState/changes`` and ``SharedEvent/events``
/// streams from services.
extension Shared {}

// swiftformat:enable emptyExtensions
