//
//  Toast.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

public struct Toast: Equatable {
    // MARK: - Properties

    public let message: String
    public let perpetuation: PerpetuationStrategy
    public let title: String?
    public let type: ToastType

    // MARK: - Init

    public init(
        _ type: ToastType = .banner(),
        title: String? = nil,
        message: String,
        perpetuation: PerpetuationStrategy = .persistent
    ) {
        self.type = type
        self.title = title
        self.message = message
        self.perpetuation = perpetuation
    }
}
