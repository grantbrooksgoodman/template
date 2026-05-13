//
//  RootSheet.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import SwiftUI

/* Proprietary */
import AppSubsystem

/// Use this extension to define views for presentation on the root
/// sheet.
///
/// The root sheet presents content above all other views in the
/// hierarchy, regardless of navigation depth. Define named sheets as
/// static properties and present them using
/// ``RootSheets/present(_:onDismiss:)``:
///
/// ```swift
/// extension RootSheet {
///     static let feedback: RootSheet = .init(.init(FeedbackView()))
/// }
///
/// RootSheets.present(.feedback)
/// ```
@MainActor
extension RootSheet {
    /// A starting value wrapping an empty view. Add static
    /// properties alongside this one for each sheet your app
    /// presents.
    static let `default`: RootSheet = .init(.init(
        EmptyView()
    ))
}
