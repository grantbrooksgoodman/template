//
//  Observables.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import Redux

public enum ObservableKey: String {
    case breadcrumbsDidCapture
    case isDeveloperModeEnabled
    case themedViewAppearanceChanged
}

/// For sending and accessing observed values between scopes.
public enum Observables {
    public static let breadcrumbsDidCapture: Observable<Nil> = .init(key: .breadcrumbsDidCapture)
    public static let isDeveloperModeEnabled: Observable<Bool> = .init(.isDeveloperModeEnabled, false)
    public static let themedViewAppearanceChanged: Observable<Nil> = .init(key: .themedViewAppearanceChanged)
}
