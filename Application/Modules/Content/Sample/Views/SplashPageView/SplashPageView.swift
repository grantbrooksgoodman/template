//
//  SplashPageView.swift
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

public struct SplashPageView: View {
    // MARK: - Constants Accessors

    private typealias Floats = AppConstants.CGFloats.SplashPageView

    // MARK: - Properties

    @StateObject private var viewModel: ViewModel<SplashPageReducer>

    // MARK: - Init

    public init(_ viewModel: ViewModel<SplashPageReducer>) {
        _viewModel = .init(wrappedValue: viewModel)
    }

    // MARK: - View

    public var body: some View {
        ThemedView {
            VStack {
                Image(uiImage: ThemeService.isDarkModeActive ? .ntWhite : .ntBlack)
                    .resizable()
                    .frame(width: Floats.imageFrameWidth, height: Floats.imageFrameHeight)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onFirstAppear {
                viewModel.send(.viewAppeared)
            }
        }
    }
}
