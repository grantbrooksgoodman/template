//
//  LocalTranslationArchiverDependency.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import CoreArchitecture
import Translator

public enum LocalTranslationArchiverDependency: DependencyKey {
    public static func resolve(_: DependencyValues) -> LocalTranslationArchiver {
        .shared
    }
}

public extension DependencyValues {
    var localTranslationArchiver: LocalTranslationArchiver {
        get { self[LocalTranslationArchiverDependency.self] }
        set { self[LocalTranslationArchiverDependency.self] = newValue }
    }
}
