//
//  SharedEvents.swift
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

/// Use this extension to declare app-specific ``EventStream`` values for
/// cross-scope communication.
///
/// Define each event as a computed property; `EventStream<Void>` suits
/// signals that carry no payload:
///
/// ```swift
/// extension SharedEvents {
///     var sessionDidExpire: EventStream<Void> { event() }
/// }
/// ```
///
/// Access an ``EventStream`` through the ``SharedEvent`` property
/// wrapper and send events with ``EventStream/send(_:)``:
///
/// ```swift
/// @SharedEvent(\.sessionDidExpire) private var sessionDidExpire
///
/// sessionDidExpire.send()
/// ```
///
/// Subscribe view models with ``ViewModelOf/observing(_:_:)``, or iterate
/// the ``EventStream/events`` stream from services.
extension SharedEvents {}

// swiftformat:enable emptyExtensions wrapPropertyBodies
