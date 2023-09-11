//
//  DevModeAction.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

public struct DevModeAction {
    
    // MARK: - Properties
    
    public let title: String
    public let perform: () -> Void
    public let isDestructive: Bool
    
    // MARK: - Init
    
    public init(title: String,
                perform: @escaping() -> Void,
                isDestructive: Bool = false) {
        self.title = title
        self.perform = perform
        self.isDestructive = isDestructive
    }
    
    // MARK: - Equality Comparison
    
    public func metadata(isEqual action: DevModeAction) -> Bool {
        let titlesMatch = title == action.title
        let isDestructivesMatch = isDestructive == action.isDestructive
        
        return titlesMatch && isDestructivesMatch
    }
    
    public func metadata(isEqual data: (title: String, isDestructive: Bool)) -> Bool {
        let titlesMatch = title == data.title
        let isDestructivesMatch = isDestructive == data.isDestructive
        
        return titlesMatch && isDestructivesMatch
    }
}
