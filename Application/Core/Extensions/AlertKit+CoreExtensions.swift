//
//  AlertKit+CoreExtensions.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import AlertKit

public extension AlertKit.Action {
    // MARK: - Properties

    static var cancelAction: AlertKit.Action {
        .init(
            Localized(.cancel).wrappedValue,
            style: .cancel
        ) {}
    }

    // MARK: - Methods

    static func cancelAction(title: String) -> AlertKit.Action {
        .init(
            title,
            style: .cancel
        ) {}
    }
}
