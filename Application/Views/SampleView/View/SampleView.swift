//
//  SampleView.swift
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

public struct SampleView: View {
    // MARK: - Properties

    @StateObject private var viewModel: ViewModel<SampleReducer>

    // MARK: - Init

    public init(_ viewModel: ViewModel<SampleReducer>) {
        _viewModel = .init(wrappedValue: viewModel)
    }

    // MARK: - View

    public var body: some View {
        Group {
            switch viewModel.viewState {
            case .loading:
                ProgressView()
            case .loaded:
                SampleContentView(viewModel)
            case let .error(exception):
                FailureView(.init(initialState: .init(exception), reducer: FailureReducer()))
            }
        }
        .onFirstAppear {
            viewModel.send(.viewAppeared)
        }
    }
}
