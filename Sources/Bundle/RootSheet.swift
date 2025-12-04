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

@MainActor
extension RootSheet {
    /* Add values here to expose new views for presentation on the root sheet. */

    static let `default`: RootSheet = .init(.init(
        EmptyView()
    ))
}
