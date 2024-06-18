//
//  SampleContentPageView.swift
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

public struct SampleContentPageView: View {
    // MARK: - Constants Accessors

    private typealias Floats = AppConstants.CGFloats.SamplePageView
    private typealias Strings = AppConstants.Strings.SamplePageView

    // MARK: - Properties

    @ObservedNavigator private var navigationCoordinator: NavigationCoordinator<RootNavigationService>
    @ObservedObject private var viewModel: ViewModel<SamplePageReducer>

    // MARK: - Bindings

    private var sheetBinding: Binding<SampleContentNavigatorState.SheetPaths?> {
        navigationCoordinator.navigable(
            \.sampleContent.sheet,
            route: { .sampleContent(.sheet($0)) }
        )
    }

    // MARK: - Init

    public init(_ viewModel: ViewModel<SamplePageReducer>) {
        self.viewModel = viewModel
    }

    // MARK: - View

    public var body: some View {
        ThemedView {
            VStack {
                Text(viewModel.strings.value(for: .titleLabelText))
                    .font(.headline)
                    .foregroundStyle(Color.titleText)

                Text(viewModel.strings.value(for: .subtitleLabelText))
                    .font(.subheadline)
                    .foregroundStyle(Color.subtitleText)

                Divider()

                HStack {
                    Button {
                        viewModel.send(.modalButtonTapped)
                    } label: {
                        Text(Strings.modalButtonText)
                            .underline()
                    }

                    Divider()
                        .frame(maxHeight: Floats.dividerFrameMaxHeight)

                    Button {
                        viewModel.send(.pushButtonTapped)
                    } label: {
                        Text(Strings.pushButtonText)
                            .underline()
                    }

                    Divider()
                        .frame(maxHeight: Floats.dividerFrameMaxHeight)

                    Button {
                        viewModel.send(.sheetButtonTapped)
                    } label: {
                        Text(Strings.sheetButtonText)
                            .underline()
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
