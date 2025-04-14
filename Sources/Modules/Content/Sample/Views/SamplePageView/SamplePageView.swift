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
    // MARK: - Properties

    @StateObject private var viewModel: ViewModel<SamplePageReducer>

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
        }
        .onFirstAppear {
            viewModel.send(.viewAppeared)
        }
    }
}

private extension Array where Element == TranslationOutputMap {
    func value(for key: TranslatedLabelStringCollection.SamplePageViewStringKey) -> String {
        (first(where: { $0.key == .samplePageView(key) })?.value ?? key.rawValue).sanitized
    }
}
