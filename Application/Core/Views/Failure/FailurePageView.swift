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
import ComponentKit
import CoreArchitecture

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
                Components.symbol(
                    Strings.imageSystemName,
                    foregroundColor: Colors.imageForegroundColor,
                    usesIntrinsicSize: false
                )
                .frame(
                    maxWidth: Floats.imageFrameMaxWidth,
                    maxHeight: Floats.imageFrameMaxHeight
                )
                .padding(.bottom, Floats.imageBottomPadding)

                Components.text(
                    viewModel.exception.userFacingDescriptor,
                    font: .systemSemibold
                )
                .padding(.vertical, Floats.exceptionLabelVerticalPadding)
                .padding(.horizontal, Floats.exceptionLabelHorizontalPadding)
                .multilineTextAlignment(.center)

                if viewModel.retryHandler != nil {
                    Components.button(
                        viewModel.retryButtonText,
                        font: .systemSemibold(scale: .custom(Floats.buttonLabelFontSize))
                    ) {
                        viewModel.send(.executeRetryHandler)
                    }
                }

                Components.button(
                    viewModel.reportBugButtonText,
                    font: .system(scale: .custom(Floats.buttonLabelFontSize)),
                    foregroundColor: viewModel.didReportBug ? .disabled : .accent
                ) {
                    viewModel.send(.reportBugButtonTapped)
                }
                .padding(.top, Floats.reportBugButtonTopPadding)
                .disabled(viewModel.didReportBug)
            }
        }
    }
}
