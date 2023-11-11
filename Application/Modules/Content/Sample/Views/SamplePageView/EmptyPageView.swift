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

/* 3rd-party */
import Redux

public struct EmptyPageView: View {
    // MARK: - Properties

    @StateObject private var viewModel: ViewModel<SamplePageReducer>

    // MARK: - Init

    public init(_ viewModel: ViewModel<SamplePageReducer>) {
        _viewModel = .init(wrappedValue: viewModel)
    }

    // MARK: - View

    public var body: some View {
        VStack {
            VStack(alignment: .center) {
                Text("Hello world")
            }
        }
        .onFirstAppear {
            viewModel.send(.viewAppeared)
        }
    }
}
