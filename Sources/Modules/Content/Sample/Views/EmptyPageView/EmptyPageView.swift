//
//  EmptyPageView.swift
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

struct EmptyPageView: View {
    // MARK: - Properties

    @StateObject private var viewModel: ViewModel<EmptyPageReducer>

    // MARK: - Init

    init(_ viewModel: ViewModel<EmptyPageReducer>) {
        _viewModel = .init(wrappedValue: viewModel)
    }

    // MARK: - View

    var body: some View {
        VStack {
            Components.text("Hello world")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onFirstAppear {
            viewModel.send(.viewAppeared)
        }
    }
}
