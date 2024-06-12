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
import CoreArchitecture

public struct BuildInfoOverlayView: View {
    // MARK: - Constants Accessors

    private typealias Colors = CoreConstants.Colors.BuildInfoOverlayView
    private typealias Floats = CoreConstants.CGFloats.BuildInfoOverlayView
    private typealias Strings = CoreConstants.Strings.BuildInfoOverlayView

    // MARK: - Properties

    @StateObject private var viewModel: ViewModel<BuildInfoOverlayReducer>
    @StateObject private var observer: ViewObserver<BuildInfoOverlayViewObserver>

    // MARK: - Init

    public init(_ viewModel: ViewModel<BuildInfoOverlayReducer>) {
        _viewModel = .init(wrappedValue: viewModel)
        _observer = .init(wrappedValue: .init(.init(viewModel)))
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
            viewModel.send(.viewAppeared)
        }
    }

    private var buildInfoButton: some View {
        Button(action: {
            viewModel.send(.buildInfoButtonTapped)
        }, label: {
            if viewModel.isDeveloperModeEnabled {
                Circle()
                    .foregroundStyle(viewModel.developerModeIndicatorDotColor)
                    .frame(
                        width: Floats.developerModeIndicatorFrameWidth,
                        height: Floats.developerModeIndicatorFrameHeight,
                        alignment: .trailing
                    )
                    .padding(.trailing, Floats.developerModeIndicatorTrailingPadding)
            }

            Text(viewModel.buildInfoButtonText)
                .font(.sanFrancisco(.bold, size: Floats.buildInfoButtonLabelFontSize))
                .foregroundStyle(Colors.buildInfoButtonLabelForeground)
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
                .font(.custom(
                    Strings.sendFeedbackButtonLabelFontName,
                    size: Floats.sendFeedbackButtonLabelFontSize
                ))
                .foregroundStyle(Colors.sendFeedbackButtonLabelForeground)
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
