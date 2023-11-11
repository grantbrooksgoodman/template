//
//  TranslatorServiceDependency.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import Redux
import Translator

public enum TranslatorServiceDependency: DependencyKey {
    public static func resolve(_: DependencyValues) -> TranslatorService {
        .shared
    }
}

public extension DependencyValues {
    var translatorService: TranslatorService {
        get { self[TranslatorServiceDependency.self] }
        set { self[TranslatorServiceDependency.self] = newValue }
    }
}
