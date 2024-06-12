//
//  RootNavigationView.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import SwiftUI

/* 3rd-party */
import CoreArchitecture

public extension RootView {
    @ViewBuilder
    var rootPage: some View {
        switch navigationCoordinator.state.modal {
        case .sampleContent:
            withTransition {
                RootContainerView()
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
}

private extension View {
    func withTransition(_ view: () -> some View) -> some View {
        view()
            .transition(AnyTransition.opacity.animation(.easeIn(duration: 0.2)))
            .zIndex(1)
    }
}
