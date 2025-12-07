//
//  DetailPageView.swift
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
import ComponentKit

struct DetailPageView: View {
    // MARK: - Constants Accessors

    private typealias Colors = AppConstants.Colors.DetailPageView
    private typealias Floats = AppConstants.CGFloats.DetailPageView
    private typealias Strings = AppConstants.Strings.DetailPageView

    // MARK: - Properties

    @StateObject private var viewModel: ViewModel<DetailPageReducer>

    // MARK: - Init

    init(_ viewModel: ViewModel<DetailPageReducer>) {
        _viewModel = .init(wrappedValue: viewModel)
    }

    // MARK: - View

    var body: some View {
        ThemedView {
            VStack {
                switch viewModel.configuration {
                case .modal,
                     .push:
                    fullScreenCoverView
                        .header(
                            leftItem: .backButton { viewModel.send(.navigateBackButtonTapped) },
                            .text(.init(viewModel.navigationTitle)),
                            popGestureAction: viewModel.popGestureAction
                        )
                        .if(viewModel.configuration == .modal) {
                            $0.fadeIn(
                                .milliseconds(Floats.modalFadeInDurationMilliseconds)
                            )
                        }

                case .sheet:
                    sheetView
                        .header(
                            .text(.init(viewModel.navigationTitle)),
                            rightItem: .doneButton(
                                foregroundColor: Colors.doneButtonForeground
                            ) {
                                viewModel.send(.navigateBackButtonTapped)
                            },
                            attributes: .init(sizeClass: .sheet)
                        )
                        .navigationBarItemGlassTint(
                            .accent,
                            for: .trailing
                        )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onFirstAppear {
                viewModel.send(.viewAppeared)
            }
        }
    }

    private var fullScreenCoverView: some View {
        VStack {
            Components.text(
                viewModel.navigationTitle,
                font: .systemBold(scale: .large)
            )

            HStack {
                Components.capsuleButton(
                    Strings.navigateBackButtonText,
                    font: .systemSemibold
                ) {
                    viewModel.send(.navigateBackButtonTapped)
                }

                Components.capsuleButton(
                    Strings.popToSplashButtonText,
                    font: .systemSemibold
                ) {
                    viewModel.send(.popToSplashButtonTapped)
                }
            }
        }
    }

    private var sheetView: some View {
        Components.capsuleButton(
            Strings.popToSplashButtonText,
            font: .systemSemibold
        ) {
            viewModel.send(.popToSplashButtonTapped)
        }
        .preferredStatusBarStyle(
            UIApplication.isFullyV26Compatible ? .default : .lightContent
        )
    }
}
