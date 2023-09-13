//
//  ThemedReducer.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import SwiftUI

/* 3rd-party */
import Redux

public struct ThemedReducer: Reducer {
    
    // MARK: - Dependencies
    
    @Dependency(\.colorProvider) private var colorProvider: ColorProvider
    @Dependency(\.coreKit.ui) private var coreUI: CoreKit.UI
    
    // MARK: - Actions
    
    public enum Action {
        case appearanceChanged
    }
    
    // MARK: - Feedback
    
    public typealias Feedback = Never
    
    // MARK: - State
    
    public struct State: Equatable {
        /* MARK: Properties */
        
        var body: (() -> any View)
        var objectID = UUID()
        var reloadsForUpdates: Bool
        var viewID = UUID()
        
        /* MARK: Init */
        
        public init(_ body: @escaping (() -> any View),
                    reloadsForUpdates: Bool = false) {
            self.body = body
            self.reloadsForUpdates = reloadsForUpdates
        }
        
        /* MARK: Equatable Conformance */
        
        public static func == (left: ThemedReducer.State, right: ThemedReducer.State) -> Bool {
            let sameObjectID = left.objectID == right.objectID
            let sameReloadsForUpdates = left.reloadsForUpdates == right.reloadsForUpdates
            let sameViewID = left.viewID == right.viewID
            
            guard sameObjectID,
                  sameViewID,
                  sameReloadsForUpdates else {
                return false
            }
            
            return true
        }
    }
    
    // MARK: - Reduce
    
    public func reduce(into state: inout State, for event: Event) -> Effect<Feedback> {
        switch event {
        case .action(.appearanceChanged):
            colorProvider.updateColorState()
            coreUI.setNavigationBarAppearance(backgroundColor: .navigationBarBackground,
                                              titleColor: .navigationBarTitle)
            state.objectID = UUID()
            
            if state.reloadsForUpdates {
                state.viewID = UUID()
            }
        }
        
        return .none
    }
}
