//
//  OnFirstAppearViewModifier.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import SwiftUI

private struct OnFirstAppearViewModifier: ViewModifier {
    // MARK: - Properties

    private var action: () -> Void
    @State private var didAppear = false

    // MARK: - Init

    public init(_ action: @escaping () -> Void) {
        self.action = action
        didAppear = false
    }

    // MARK: - Body

    public func body(content: Content) -> some View {
        content.onAppear {
            guard !didAppear else { return }
            didAppear = true
            action()
        }
    }
}

public extension View {
    func onFirstAppear(_ action: @escaping (() -> Void)) -> some View {
        modifier(OnFirstAppearViewModifier(action))
    }
}
