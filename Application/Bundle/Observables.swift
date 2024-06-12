//
//  Observables.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import CoreArchitecture

public enum ObservableKey: String {
    // MARK: - App Cases

    /* Add cases here to define new values for Observer instances. */

    // MARK: - Core Cases

    case breadcrumbsDidCapture
    case isDeveloperModeEnabled
    case rootViewSheet
    case rootViewToast
    case rootViewToastAction
    case themedViewAppearanceChanged
}

/// For sending and accessing observed values between scopes.
public enum Observables {
    /* Add new properties conforming to Observable here. */
}
