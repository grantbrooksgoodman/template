//
//  RootWindow.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import SwiftUI

/* 3rd-party */
import CoreArchitecture

/// Added as a subview to the key window and is perpetually frontmost.
public struct RootWindow: View {
    // MARK: - Properties

    @StateObject private var observer: ViewObserver<RootWindowObserver>
    @StateObject private var viewModel: ViewModel<RootReducer>

    // MARK: - Bindings

    private var sheetBinding: Binding<Bool> {
        viewModel.binding(
            for: \.isPresentingSheet,
            sendAction: { .isPresentingSheetChanged($0) }
        )
    }

    private var toastBinding: Binding<Toast?> {
        viewModel.binding(
            for: \.toast,
            sendAction: { .toastChanged($0) }
        )
    }

    // MARK: - Init

    public init(_ viewModel: ViewModel<RootReducer>) {
        _viewModel = .init(wrappedValue: viewModel)
        _observer = .init(wrappedValue: .init(.init(viewModel)))
    }

    // MARK: - View

    public var body: some View {
        EmptyView()
            .sheet(isPresented: sheetBinding) {
                viewModel.sheet
            }
            .toast(toastBinding) {
                viewModel.send(.toastTapped)
            }
            .onFirstAppear {
                viewModel.send(.viewAppeared)
            }
    }
}
