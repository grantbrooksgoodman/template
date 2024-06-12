//
//  RootNavigatorState.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import Redux

public struct RootNavigatorState: NavigatorState {
    // MARK: - Types

    public enum ModalPaths: Paths {
        case splash
        case sampleContent
    }

    public enum SeguePaths: Paths {}

    // MARK: - Properties

    public var sampleContent: SampleContentNavigatorState = .init()

    public var modal: ModalPaths?
    public var stack: [SeguePaths] = []
}
