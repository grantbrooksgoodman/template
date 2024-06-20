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

/* 3rd-party */
import ComponentKit
import CoreArchitecture

public struct DetailPageView: View {
    // MARK: - Constants Accessors

    private typealias Floats = AppConstants.CGFloats.DetailPageView
    private typealias Strings = AppConstants.Strings.DetailPageView

    // MARK: - Properties

    @StateObject private var viewModel: ViewModel<DetailPageReducer>

    // MARK: - Init

    public init(_ viewModel: ViewModel<DetailPageReducer>) {
        _viewModel = .init(wrappedValue: viewModel)
    }

    // MARK: - View

    public var body: some View {
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

                case .sheet:
                    sheetView
                        .header(
                            rightItem: .doneButton { viewModel.send(.navigateBackButtonTapped) },
                            attributes: .init(sizeClass: .sheet)
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
                font: .systemBold
            )

            Divider()

            HStack {
                Components.button(
                    Strings.navigateBackButtonText,
                    font: .systemMediumUnderlined
                ) {
                    viewModel.send(.navigateBackButtonTapped)
                }

                Divider()
                    .frame(maxHeight: Floats.dividerFrameMaxHeight)

                Components.button(
                    Strings.popToSplashButtonText,
                    font: .systemMediumUnderlined
                ) {
                    viewModel.send(.popToSplashButtonTapped)
                }
            }
        }
    }

    private var sheetView: some View {
        VStack {
            Components.text(
                viewModel.navigationTitle,
                font: .systemBold
            )

            Divider()

            Components.button(
                Strings.popToSplashButtonText,
                font: .systemMediumUnderlined
            ) {
                viewModel.send(.popToSplashButtonTapped)
            }
        }
        .preferredStatusBarStyle(.lightContent)
    }
}
