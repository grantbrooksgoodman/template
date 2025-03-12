//
//  SampleContentContainerView.swift
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

public struct SampleContentContainerView: View {
    // MARK: - Properties

    @ObservedNavigator private var navigationCoordinator: NavigationCoordinator<RootNavigationService>

    // MARK: - Bindings

    private var navigationPathBinding: Binding<[SampleContentNavigatorState.SeguePaths]> {
        navigationCoordinator.navigable(
            \.sampleContent.stack,
            route: { .sampleContent(.stack($0)) }
        )
    }

    // MARK: - View

    @ViewBuilder
    public var body: some View {
        switch navigationCoordinator.state.sampleContent.modal {
        case .modalDetail:
            DetailPageView(
                .init(
                    initialState: .init(.modal),
                    reducer: DetailPageReducer()
                )
            )

        case .none:
            NavigationStack(path: navigationPathBinding) {
                SamplePageView(
                    .init(
                        initialState: .init(),
                        reducer: SamplePageReducer()
                    )
                )
                .navigationDestination(for: SampleContentNavigatorState.SeguePaths.self) { destinationView(for: $0) }
            }
        }
    }

    // MARK: - Auxiliary

    @ViewBuilder
    private func destinationView(for path: SampleContentNavigatorState.SeguePaths) -> some View {
        switch path {
        case .pushDetail:
            DetailPageView(
                .init(
                    initialState: .init(.push),
                    reducer: DetailPageReducer()
                )
            )
        }
    }
}
