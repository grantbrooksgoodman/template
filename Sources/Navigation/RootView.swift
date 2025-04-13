//
//  RootView.swift
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
import Networking

public struct RootView: View {
    // MARK: - Dependencies

    @ObservedDependency(\.navigation) private var navigation: Navigation

    // MARK: - Body

    public var body: some View {
        ZStack {
            switch navigation.state.modal {
            case .sampleContent:
                withTransition {
                    SampleContentContainerView()
                }

            case .splash:
                withTransition {
                    SplashPageView(
                        .init(
                            initialState: .init(),
                            reducer: SplashPageReducer()
                        )
                    )
                }

            case .none:
                EmptyView()
            }
        }
        .indicatesNetworkActivity()
    }
}

private extension View {
    func withTransition(_ view: () -> some View) -> some View {
        view()
            .transition(AnyTransition.opacity.animation(.easeIn(duration: 0.2)))
            .zIndex(1)
    }
}
