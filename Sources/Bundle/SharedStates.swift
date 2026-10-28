//
//  SharedStates.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

// swiftformat:disable emptyExtensions wrapPropertyBodies

/* Native */
import Foundation

/* Proprietary */
import AppSubsystem

/// Use this extension to declare app-specific ``StateStream`` values for
/// cross-scope communication.
///
/// Define each value as a computed property:
///
/// ```swift
/// extension SharedStates {
///     var isLoggedIn: StateStream<Bool> { state(false) }
/// }
/// ```
///
/// Access a ``StateStream`` through the ``SharedState`` property wrapper:
///
/// ```swift
/// @SharedState(\.isLoggedIn) private var isLoggedIn
///
/// isLoggedIn = true
/// ```
///
/// Subscribe view models with ``ViewModelOf/observing(_:_:)``, or iterate
/// the ``StateStream/changes`` stream from services.
extension SharedStates {}

// swiftformat:enable emptyExtensions wrapPropertyBodies
