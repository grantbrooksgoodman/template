//
//  RootView.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import SwiftUI

/* 3rd-party */
import Redux

public struct RootView: View {
    // MARK: - Dependencies

    @ObservedDependency(\.rootNavigationCoordinator) public var navigationCoordinator: RootNavigationCoordinator

    // MARK: - View

    public var body: some View {
        GeometryReader { proxy in
            rootPage
                .environment(\.keyWindowSize, proxy.size)
        }
    }
}
