//
//  RedrawsOnTraitCollectionChangeViewModifier.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import SwiftUI

// swiftlint:disable:next type_name
private struct RedrawsOnTraitCollectionChangeViewModifier: ViewModifier {
    // MARK: - Properties

    @State private var viewID = UUID()

    // MARK: - Body

    public func body(content: Content) -> some View {
        content
            .id(viewID)
            .onTraitCollectionChange { viewID = UUID() }
    }
}

public extension View {
    func redrawsOnTraitCollectionChange() -> some View {
        modifier(RedrawsOnTraitCollectionChangeViewModifier())
    }
}
