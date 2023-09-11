//
//  UITraitCollectionDependency.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import UIKit

/* 3rd-party */
import Redux

public enum UITraitCollectionDependency: DependencyKey {
    public static func resolve(_ dependencies: DependencyValues) -> UITraitCollection {
        UITraitCollection.current
    }
}

public extension DependencyValues {
    var uiTraitCollection: UITraitCollection {
        get {
            self[UITraitCollectionDependency.self]
        }
        set {
            self[UITraitCollectionDependency.self] = newValue
        }
    }
}
