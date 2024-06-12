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

public enum RootSheet {
    // MARK: - Cases

    /* Add cases here to expose new views for presentation on the root sheet. */

    case `default`

    // MARK: - Properties

    @MainActor
    public var view: AnyView {
        switch self {
        case .default:
            return .init(
                ThemedView {
                    Text("Root Sheet")
                        .header(
                            rightItem: .doneButton { RootSheets.dismiss() },
                            attributes: .init(sizeClass: .sheet)
                        )
                        .preferredStatusBarStyle(.lightContent)
                }
            )
        }
    }
}
