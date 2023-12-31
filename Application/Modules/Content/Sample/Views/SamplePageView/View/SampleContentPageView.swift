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
import Redux

public struct SampleContentPageView: View {
    // MARK: - Properties

    @ObservedObject private var viewModel: ViewModel<SamplePageReducer>

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
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background)
        }
    }
}

private extension Array where Element == TranslationOutputMap {
    func value(for key: TranslatedLabelStringCollection.SamplePageViewStringKey) -> String {
        (first(where: { $0.key == .samplePageView(key) })?.value ?? key.rawValue).sanitized
    }
}
