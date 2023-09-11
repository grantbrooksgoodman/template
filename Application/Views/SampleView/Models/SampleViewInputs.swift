//
//  SampleViewInputs.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import Translator

public struct SampleViewInputs: Equatable {
    
    // MARK: - Properties
    
    public let titleLabelText: TranslationInput
    public let subtitleLabelText: TranslationInput
    
    public var array: [TranslationInput] {
        [
            titleLabelText,
            subtitleLabelText
        ]
    }
    
    // MARK: - Init
    
    public init(titleLabelText: TranslationInput,
                subtitleLabelText: TranslationInput) {
        self.titleLabelText = titleLabelText
        self.subtitleLabelText = subtitleLabelText
    }
    
    // MARK: - Static Accessors
    
    public static var `default`: SampleViewInputs {
        .init(titleLabelText: .init("Hello World"),
              subtitleLabelText: .init("In redux!"))
    }
    
    public static var empty: SampleViewInputs {
        .init(titleLabelText: .init(""),
              subtitleLabelText: .init(""))
    }
}
