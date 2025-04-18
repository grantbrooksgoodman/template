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

    public var body: some View {
        ZStack {
            Color.clear
                .frame(width: .zero, height: .zero)
                .preferredStatusBarStyle(ThemeService.isDarkModeActive ? .lightContent : .darkContent)
                .redrawsOnTraitCollectionChange()

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
}
