//
//  BuildInfoOverlayView.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import SwiftUI

/* 3rd-party */
import Redux

public struct BuildInfoOverlayView: View {
    // MARK: - Properties

    @StateObject private var viewModel: ViewModel<BuildInfoOverlayReducer>

    // MARK: - Constants Accessors

    private typealias Colors = AppConstants.Colors.BuildInfoOverlayView
    private typealias Floats = AppConstants.CGFloats.BuildInfoOverlayView
    private typealias Strings = AppConstants.Strings.BuildInfoOverlayView

    // MARK: - Init

    public init(_ viewModel: ViewModel<BuildInfoOverlayReducer>) {
        _viewModel = .init(wrappedValue: viewModel)
    }

    // MARK: - View

    public var body: some View {
        Group {
            VStack {
                Group {
                    sendFeedbackButton
                    buildInfoButton
                }
            }
            .offset(x: Floats.xOffset, y: viewModel.yOffset)
            .onShake {
                viewModel.send(.didShakeDevice)
            }
        }
        .onFirstAppear {
            Observers.register(observer: BuildInfoOverlayViewObserver(viewModel))
            viewModel.send(.viewAppeared)
        }
    }

    private var buildInfoButton: some View {
        Button(action: {
            viewModel.send(.buildInfoButtonTapped)
        }, label: {
            if viewModel.isDeveloperModeEnabled {
                Circle()
                    .foregroundColor(viewModel.developerModeIndicatorDotColor)
                    .frame(
                        width: Floats.developerModeIndicatorFrameWidth,
                        height: Floats.developerModeIndicatorFrameHeight,
                        alignment: .trailing
                    )
                    .padding(.trailing, Floats.developerModeIndicatorTrailingPadding)
            }

            Text(viewModel.buildInfoButtonText)
                .font(Font.custom(
                    Strings.buildInfoButtonLabelFontName,
                    size: Floats.buildInfoButtonLabelFontSize
                ))
                .foregroundColor(Colors.buildInfoButtonLabelForeground)
        })
        .padding(.all, Floats.buildInfoButtonPadding)
        .frame(height: Floats.buildInfoButtonFrameHeight)
        .background(Colors.buildInfoButtonBackground)
        .frame(
            maxWidth: .infinity,
            alignment: .trailing
        )
        .offset(x: Floats.buildInfoButtonXOffset)
    }

    private var sendFeedbackButton: some View {
        Button(action: {
            viewModel.send(.sendFeedbackButtonTapped)
        }, label: {
            Text(viewModel.sendFeedbackButtonText)
                .font(Font.custom(
                    Strings.sendFeedbackButtonLabelFontName,
                    size: Floats.sendFeedbackButtonLabelFontSize
                ))
                .foregroundColor(Colors.sendFeedbackButtonLabelForeground)
                .underline()
        })
        .padding(.horizontal, Floats.sendFeedbackButtonHorizontalPadding)
        .frame(height: Floats.sendFeedbackButtonFrameHeight)
        .background(Colors.sendFeedbackButtonBackground)
        .frame(
            maxWidth: .infinity,
            alignment: .trailing
        )
        .offset(
            x: Floats.sendFeedbackButtonXOffset,
            y: Floats.sendFeedbackButtonYOffset
        )
    }
}
