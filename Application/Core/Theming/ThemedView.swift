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

    private var redrawsOnAppearanceChange = false
    private var viewBody: () -> any View

    // MARK: - Init

    public init(
        redrawsOnAppearanceChange: Bool = false,
        _ body: @escaping () -> any View
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
    @StateObject private var observer: ViewObserver<ThemedViewObserver>

    // MARK: - Init

    public init(_ viewModel: ViewModel<ThemedReducer>) {
        _viewModel = .init(wrappedValue: viewModel)
        _observer = .init(wrappedValue: .init(.init(viewModel)))
    }

    // MARK: - View

    public var body: some View {
        AnyView(viewModel.body())
            .id(viewModel.viewID)
    }
}
