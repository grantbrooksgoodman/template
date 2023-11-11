//
//  BuildInfoOverlayReducer.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import SwiftUI

/* 3rd-party */
import Redux

public struct BuildInfoOverlayReducer: Reducer {
    // MARK: - Dependencies

    @Dependency(\.build) private var build: Build
    @Dependency(\.buildInfoOverlayViewService) private var viewService: BuildInfoOverlayViewService

    // MARK: - Actions

    public enum Action {
        case viewAppeared

        case buildInfoButtonTapped
        case didShakeDevice
        case sendFeedbackButtonTapped

        case breadcrumbsDidCapture
        case isDeveloperModeEnabledChanged(Bool)
    }

    // MARK: - Feedback

    public enum Feedback {
        case restoreIndicatorColor
    }

    // MARK: - State

    public struct State: Equatable {
        /* MARK: Properties */

        // String
        @Localized(.sendFeedback) public var sendFeedbackButtonText: String
        public var buildInfoButtonText = ""

        // Other
        public var developerModeIndicatorDotColor: Color = .orange
        public var isDeveloperModeEnabled = false
        public var yOffset: CGFloat

        /* MARK: Init */

        public init(_ yOffset: CGFloat = 0) {
            self.yOffset = yOffset
        }
    }

    // MARK: - Init

    public init() { RuntimeStorage.store(#file, as: .presentedViewName) }

    // MARK: - Reduce

    public func reduce(into state: inout State, for event: Event) -> Effect<Feedback> {
        switch event {
        case .action(.viewAppeared):
            state.buildInfoButtonText = "\(build.codeName) \(build.bundleVersion) (\(String(build.buildNumber))\(build.stage.shortString))"

            @Persistent(.developerModeEnabled) var defaultsValue: Bool?
            guard let defaultsValue else { return .none }
            state.isDeveloperModeEnabled = defaultsValue

        case .action(.buildInfoButtonTapped):
            viewService.buildInfoButtonTapped()

        case .action(.didShakeDevice):
            guard build.developerModeEnabled else { return .none }
            DevModeService.presentActionSheet()

        case .action(.breadcrumbsDidCapture):
            state.developerModeIndicatorDotColor = .red
            return .task(delay: .seconds(1.5)) {
                .restoreIndicatorColor
            }

        case let .action(.isDeveloperModeEnabledChanged(developerModeEnabled)):
            state.isDeveloperModeEnabled = developerModeEnabled

        case .action(.sendFeedbackButtonTapped):
            viewService.sendFeedbackButtonTapped()

        case .feedback(.restoreIndicatorColor):
            state.developerModeIndicatorDotColor = .orange
        }

        return .none
    }
}
