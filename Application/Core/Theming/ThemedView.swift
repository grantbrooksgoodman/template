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
import CoreArchitecture

public struct ThemedView: View {
    // MARK: - Properties

    private let navigationBarAppearance: NavigationBarAppearance?
    private let redrawsOnAppearanceChange: Bool
    private let viewBody: () -> any View

    // MARK: - Init

    public init(
        navigationBarAppearance: NavigationBarAppearance? = .themed(),
        redrawsOnAppearanceChange: Bool = false,
        _ body: @escaping () -> any View
    ) {
        viewBody = body
        self.navigationBarAppearance = navigationBarAppearance
        self.redrawsOnAppearanceChange = redrawsOnAppearanceChange
    }

    // MARK: - View

    public var body: some View {
        Themed(
            .init(
                initialState: .init(
                    viewBody,
                    navigationBarAppearance: navigationBarAppearance,
                    redrawsOnAppearanceChange: redrawsOnAppearanceChange
                ),
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
            .onFirstAppear {
                viewModel.send(.viewAppeared)
            }
            .onDisappear {
                viewModel.send(.viewDisappeared)
            }
    }
}
