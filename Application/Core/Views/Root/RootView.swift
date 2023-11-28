//
//  RootView.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import SwiftUI

/* 3rd-party */
import Redux

public struct RootView: View {
    // MARK: - Dependencies

    @Dependency(\.rootNavigationCoordinator) public var navigationCoordinator: RootNavigationCoordinator

    // MARK: - Properties

    @StateObject private var viewModel: ViewModel<RootReducer>
    @StateObject private var observer: ViewObserver<RootViewObserver>

    // MARK: - Bindings

    private var toastBinding: Binding<Toast?> {
        viewModel.binding(
            for: \.toast,
            sendAction: { .toastChanged($0) }
        )
    }

    // MARK: - Init

    public init(_ viewModel: ViewModel<RootReducer>) {
        _viewModel = .init(wrappedValue: viewModel)
        _observer = .init(wrappedValue: .init(.init(viewModel)))
    }

    // MARK: - View

    public var body: some View {
        GeometryReader { proxy in
            rootPage
                .environment(\.keyWindowSize, proxy.size)
        }
        .toast(toastBinding) {
            viewModel.send(.toastTapped)
        }
    }
}
