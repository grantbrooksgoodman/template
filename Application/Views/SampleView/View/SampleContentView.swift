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
                Text(viewModel.strings.titleLabelText)
                    .font(.headline)
                    .foregroundColor(.titleText)

                Text(viewModel.strings.subtitleLabelText)
                    .font(.subheadline)
                    .foregroundColor(.subtitleText)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background)
        }
    }
}
