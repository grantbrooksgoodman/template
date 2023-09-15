//
//  ThemedView.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import SwiftUI

/* 3rd-party */
import Redux

public struct ThemedView: View {
    // MARK: - Properties

    public var redrawsOnAppearanceChange = false
    public var viewBody: () -> any View

    // MARK: - Init

    public init(
        _ body: @escaping () -> any View,
        redrawsOnAppearanceChange: Bool = false
    ) {
        viewBody = body
        self.redrawsOnAppearanceChange = redrawsOnAppearanceChange
    }

    // MARK: - View

    public var body: some View {
        Themed(
            .init(
                initialState: .init(viewBody, redrawsOnAppearanceChange: redrawsOnAppearanceChange),
                reducer: ThemedReducer()
            )
        )
    }
}

private struct Themed: View {
    // MARK: - Properties

    @StateObject private var viewModel: ViewModel<ThemedReducer>

    // MARK: - Init

    public init(_ viewModel: ViewModel<ThemedReducer>) {
        _viewModel = .init(wrappedValue: viewModel)
    }

    // MARK: - View

    public var body: some View {
        AnyView(viewModel.body())
            .id(viewModel.viewID)
            .onFirstAppear {
                Observers.register(observer: ThemedViewObserver(viewModel))
            }
    }
}
