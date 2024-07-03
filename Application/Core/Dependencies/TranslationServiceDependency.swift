//
//  TranslationServiceDependency.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import CoreArchitecture
import Translator

public enum TranslationServiceDependency: DependencyKey {
    public static func resolve(_: DependencyValues) -> TranslationService {
        .shared
    }
}

public extension DependencyValues {
    var translationService: TranslationService {
        get { self[TranslationServiceDependency.self] }
        set { self[TranslationServiceDependency.self] = newValue }
    }
}
