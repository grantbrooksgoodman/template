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
    // MARK: - Dependencies

    @ObservedDependency(\.navigation) private var navigation: Navigation

    // MARK: - View

    @ViewBuilder
    public var body: some View {
        switch navigation.state.sampleContent.modal {
        case .none:
            SamplePageView(
                .init(
                    initialState: .init(),
                    reducer: SamplePageReducer()
                )
            )
        }
    }
}
