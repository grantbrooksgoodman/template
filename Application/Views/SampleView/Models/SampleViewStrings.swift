//
//  SampleViewStrings.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

public struct SampleViewStrings: Equatable {
    // MARK: - Properties

    public var titleLabelText: String
    public var subtitleLabelText: String

    // MARK: - Init

    public init(
        titleLabelText: String,
        subtitleLabelText: String
    ) {
        self.titleLabelText = titleLabelText
        self.subtitleLabelText = subtitleLabelText
    }

    // MARK: - Static Accessors

    public static var `default`: SampleViewStrings {
        let inputs = SampleViewInputs.default
        return .init(
            titleLabelText: inputs.titleLabelText.value(),
            subtitleLabelText: inputs.subtitleLabelText.value()
        )
    }

    public static var empty: SampleViewStrings {
        .init(
            titleLabelText: "",
            subtitleLabelText: ""
        )
    }
}
