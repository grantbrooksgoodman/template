//
//  ThemedView.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import SwiftUI

/* 3rd-party */
import Redux

public struct ThemedView: View {
    
    // MARK: - Properties
    
    public var reloadsForUpdates = false
    public var viewBody: (() -> any View)
    
    // MARK: - Init
    
    public init(_ body: @escaping () -> any View,
                reloadsForUpdates: Bool = false) {
        self.viewBody = body
        self.reloadsForUpdates = reloadsForUpdates
    }
    
    // MARK: - View
    
    public var body: some View {
        Themed(
            .init(
                initialState: .init(viewBody, reloadsForUpdates: reloadsForUpdates),
                reducer: ThemedReducer()
            )
        )
    }
}

private struct Themed: View {
    // MARK: - Properties
    
    @StateObject private var viewModel: ViewModel<ThemedReducer>
    
    // MARK: - Init
    
    public init(_ viewModel: ViewModel<ThemedReducer>) {
        self._viewModel = .init(wrappedValue: viewModel)
    }
    
    // MARK: - View
    
    public var body: some View {
        AnyView(viewModel.body())
            .id(viewModel.viewID)
            .onFirstAppear {
                Observers.register(observer: ThemedViewObserver(viewModel))
                viewModel.send(.viewAppeared)
            }
    }
}
