//
//  SamplePageView.swift
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

public struct SamplePageView: View {
    // MARK: - Constants Accessors

    private typealias Floats = AppConstants.CGFloats.SamplePageView
    private typealias Strings = AppConstants.Strings.SamplePageView

    // MARK: - Dependencies

    @ObservedDependency(\.navigation) private var navigation: Navigation

    // MARK: - Properties

    @StateObject private var viewModel: ViewModel<SamplePageReducer>

    // MARK: - Bindings

    private var sheetBinding: Binding<SampleContentNavigatorState.SheetPaths?> {
        navigation.navigable(
            \.sampleContent.sheet,
            route: { .sampleContent(.sheet($0)) }
        )
    }

    // MARK: - Init

    public init(_ viewModel: ViewModel<SamplePageReducer>) {
        _viewModel = .init(wrappedValue: viewModel)
    }

    // MARK: - View

    public var body: some View {
        StatefulView(viewModel.binding(for: \.viewState)) {
            ThemedView {
                VStack {
                    Components.text(
                        viewModel.strings.value(for: .titleLabelText),
                        font: .systemBold
                    )

                    Components.text(
                        viewModel.strings.value(for: .subtitleLabelText),
                        font: .system(scale: .small),
                        foregroundColor: .subtitleText
                    )

                    Divider()

                    HStack {
                        Components.button(
                            Strings.modalButtonText,
                            font: .systemMediumUnderlined
                        ) {
                            viewModel.send(.modalButtonTapped)
                        }

                        Divider()
                            .frame(maxHeight: Floats.dividerFrameMaxHeight)

                        Components.button(
                            Strings.pushButtonText,
                            font: .systemMediumUnderlined
                        ) {
                            viewModel.send(.pushButtonTapped)
                        }

                        Divider()
                            .frame(maxHeight: Floats.dividerFrameMaxHeight)

                        Components.button(
                            Strings.sheetButtonText,
                            font: .systemMediumUnderlined
                        ) {
                            viewModel.send(.sheetButtonTapped)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.background)
                .header(
                    .image(.init(
                        foregroundColor: .titleText,
                        image: .init(uiImage: .ntBlack)
                    ))
                )
            }
            .sheet(item: sheetBinding) { sheetView(for: $0) }
        }
        .onFirstAppear {
            viewModel.send(.viewAppeared)
        }
    }

    // MARK: - Auxiliary

    @ViewBuilder
    private func sheetView(for path: SampleContentNavigatorState.SheetPaths) -> some View {
        switch path {
        case .sheetDetail:
            DetailPageView(
                .init(
                    initialState: .init(.sheet),
                    reducer: DetailPageReducer()
                )
            )
        }
    }
}

private extension Array where Element == TranslationOutputMap {
    func value(for key: TranslatedLabelStringCollection.SamplePageViewStringKey) -> String {
        (first(where: { $0.key == .samplePageView(key) })?.value ?? key.rawValue).sanitized
    }
}
