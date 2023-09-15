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

/* 3rd-party */
import Redux

public struct RootView: View {
    // MARK: - Properties

    @ObservedDependency(\.rootNavigationCoordinator) private var navigationCoordinator: RootNavigationCoordinator

    // MARK: - View

    public var body: some View {
        Group {
            switch navigationCoordinator.page {
            case .sample:
                withTransition { SampleView(.init(initialState: .init(), reducer: SampleReducer())) }
            }
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
