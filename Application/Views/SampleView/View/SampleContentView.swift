//
//  SampleContentView.swift
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

public struct SampleContentView: View {
    // MARK: - Properties

    @ObservedObject private var viewModel: ViewModel<SampleReducer>

    // MARK: - Init

    public init(_ viewModel: ViewModel<SampleReducer>) {
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
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background)
        }
    }
}

private extension Array where Element == TranslationOutputMap {
    func value(for key: TranslatedLabelStringCollection.SampleViewStringKey) -> String {
        (first(where: { $0.key == .sampleView(key) })?.value ?? key.rawValue).sanitized
    }
}
