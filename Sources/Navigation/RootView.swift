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

/// The app's root SwiftUI view.
///
/// `RootView` observes the navigation coordinator and renders the
/// appropriate top-level screen based on the current
/// ``RootNavigatorState/modal`` value. Add a `case` to the `switch`
/// statement in `body` for each destination defined in
/// ``RootNavigatorState/ModalPaths``.
///
/// ``SceneDelegate`` attaches this view to the window scene at launch
/// through ``RootWindowScene/instantiate(_:rootView:)``.
struct RootView: View {
    // MARK: - Dependencies

    @ObservedDependency(\.navigation) private var navigation: Navigation

    // MARK: - Body

    var body: some View {
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
}

private extension View {
    func withTransition(_ view: () -> some View) -> some View {
        view()
            .transition(AnyTransition.opacity.animation(.easeIn(duration: 0.2)))
            .zIndex(1)
    }
}
