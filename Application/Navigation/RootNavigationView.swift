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
import Redux

public extension RootView {
    var rootPage: some View {
        Group {
            switch navigationCoordinator.page {
            case .sample:
                withTransition { SamplePageView(.init(initialState: .init(), reducer: SamplePageReducer())) }
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
