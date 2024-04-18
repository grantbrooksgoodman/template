//
//  NavigationBarAppearanceViewModifier.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import SwiftUI

private struct NavigationBarAppearanceViewModifier: ViewModifier {
    // MARK: - Properties

    private let appearance: NavigationBarAppearance
    private let previousAppearance: NavigationBarAppearance?

    @State private var viewID = UUID()

    // MARK: - Init

    public init(_ appearance: NavigationBarAppearance) {
        self.appearance = appearance
        previousAppearance = NavigationBar.currentAppearance
    }

    // MARK: - Body

    public func body(content: Content) -> some View {
        content
            .id(viewID)
            .onAppear {
                NavigationBar.setAppearance(appearance)
            }
            .onTraitCollectionChange {
                NavigationBar.setAppearance(appearance)
                viewID = UUID()
            }
            .onDisappear {
                guard let previousAppearance else { return }
                NavigationBar.setAppearance(previousAppearance)
            }
    }
}

public extension View {
    func navigationBarAppearance(_ appearance: NavigationBarAppearance) -> some View {
        modifier(NavigationBarAppearanceViewModifier(appearance))
    }
}
