//
//  FailurePageView.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import SwiftUI

/* 3rd-party */
import Redux

public struct FailurePageView: View {
    // MARK: - Constants Accessors

    private typealias Colors = CoreConstants.Colors.FailureView
    private typealias Floats = CoreConstants.CGFloats.FailureView
    private typealias Strings = CoreConstants.Strings.FailureView

    // MARK: - Properties

    @StateObject private var viewModel: ViewModel<FailurePageReducer>

    // MARK: - Init

    public init(_ viewModel: ViewModel<FailurePageReducer>) {
        _viewModel = .init(wrappedValue: viewModel)
    }

    // MARK: - View

    public var body: some View {
        ThemedView {
            VStack {
                Image(systemName: Strings.imageSystemName)
                    .renderingMode(.template)
                    .foregroundStyle(Colors.imageForegroundColor)
                    .font(.system(size: Floats.imageSystemSize))
                    .padding(.bottom, Floats.imageBottomPadding)

                Text(viewModel.exception.userFacingDescriptor)
                    .font(.sanFrancisco(.semibold, size: Floats.exceptionLabelFontSize))
                    .foregroundStyle(Color.titleText)
                    .padding(.vertical, Floats.exceptionLabelVerticalPadding)
                    .padding(.horizontal, Floats.exceptionLabelHorizontalPadding)
                    .multilineTextAlignment(.center)

                if viewModel.retryHandler != nil {
                    Button {
                        viewModel.send(.executeRetryHandler)
                    } label: {
                        Text(viewModel.retryButtonText)
                            .font(.system(size: Floats.buttonLabelFontSize, weight: .semibold))
                            .foregroundStyle(Color.accent)
                    }
                }

                Button {
                    viewModel.send(.reportBugButtonTapped)
                } label: {
                    Text(viewModel.reportBugButtonText)
                        .font(.system(size: Floats.buttonLabelFontSize))
                        .foregroundStyle(viewModel.didReportBug ? Color.disabled : .accent)
                }
                .padding(.top, Floats.reportBugButtonTopPadding)
                .disabled(viewModel.didReportBug)
            }
        }
    }
}
