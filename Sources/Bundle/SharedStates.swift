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

/// Use this extension to declare app-specific ``StateStream`` values
/// for cross-scope communication.
///
/// Define each value as a computed property:
///
/// ```swift
/// extension SharedStates {
///     var isLoggedIn: StateStream<Bool> { state(false) }
/// }
/// ```
///
/// Access a ``StateStream`` through the ``SharedState`` property
/// wrapper:
///
/// ```swift
/// @SharedState(\.isLoggedIn) private var isLoggedIn
///
/// isLoggedIn = true
/// ```
///
/// Subscribe view models with ``ViewModelOf/observing(_:_:)``, or
/// iterate the ``StateStream/changes`` stream from services.
///
/// - Important: ``SharedState`` is not a SwiftUI `DynamicProperty`.
///   Reading a shared value in a view's `body` doesn't invalidate
///   the view when the value changes. Reactivity flows exclusively
///   through ``ViewModelOf/observing(_:_:)`` – map each change to a
///   reducer action and drive view updates from reducer state.
///
/// - Warning: Call ``SharedStates/state(_:key:fileID:)`` only from
///   the body of the computed property that declares the value.
///   Calling it from anywhere else silently creates a
///   differently-keyed instance.
extension SharedStates {}

// swiftformat:enable emptyExtensions wrapPropertyBodies
