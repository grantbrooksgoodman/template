//
//  BuildInfoOverlayReducer.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import Redux

public struct BuildInfoOverlayReducer: Reducer {
    
    // MARK: - Dependencies
    
    @Dependency(\.userDefaults) private var defaults: UserDefaults
    @Dependency(\.buildInfoOverlayViewService) private var service: BuildInfoOverlayViewService
    
    // MARK: - Actions
    
    public enum Action {
        case viewAppeared
        
        case buildInfoButtonTapped
        case didShakeDevice
        case sendFeedbackButtonTapped
        
        case isDeveloperModeEnabledChanged(Bool)
    }
    
    // MARK: - Feedback
    
    public typealias Feedback = Never
    
    // MARK: - State
    
    public struct State: Equatable {
        
        /* MARK: Properties */
        
        // Strings
        var buildInfoButtonText: String = ""
        @Localized(.sendFeedback) var sendFeedbackButtonText: String
        
        // Other
        var isDeveloperModeEnabled: Bool = false
        var yOffset: CGFloat
        
        /* MARK: Init */
        
        public init(_ yOffset: CGFloat = 0) {
            self.yOffset = yOffset
        }
    }
    
    // MARK: - Reduce
    
    public func reduce(into state: inout State, for event: Event) -> Effect<Feedback> {
        switch event {
        case .action(.viewAppeared):
            RuntimeStorage.store(#file, as: .currentFile)
            
            state.buildInfoButtonText = "\(Build.codeName) \(Build.bundleVersion) (\(String(Build.buildNumber))\(Build.stage.description(short: true)))"
            if let defaultsValue = defaults.value(forKey: .developerModeEnabled) as? Bool {
                state.isDeveloperModeEnabled = defaultsValue
            }
            
        case .action(.buildInfoButtonTapped):
            service.buildInfoButtonTapped()
            
        case .action(.didShakeDevice):
            guard Build.developerModeEnabled else { return .none }
            DevModeService.presentActionSheet()
            
        case let .action(.isDeveloperModeEnabledChanged(developerModeEnabled)):
            state.isDeveloperModeEnabled = developerModeEnabled
            
        case .action(.sendFeedbackButtonTapped):
            service.sendFeedbackButtonTapped()
        }
        
        return .none
    }
}
