//
//  MailComposerDependency.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import CoreArchitecture

public enum MailComposerDependency: DependencyKey {
    public static func resolve(_: DependencyValues) -> MailComposer {
        .shared
    }
}

public extension DependencyValues {
    var mailComposer: MailComposer {
        get { self[MailComposerDependency.self] }
        set { self[MailComposerDependency.self] = newValue }
    }
}
