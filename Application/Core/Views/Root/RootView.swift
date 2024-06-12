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
import CoreArchitecture

public struct RootView: View {
    // MARK: - Properties

    @ObservedNavigator public var navigationCoordinator: NavigationCoordinator<RootNavigationService>

    // MARK: - View

    public var body: some View {
        GeometryReader { proxy in
            rootPage
                .environment(\.keyWindowSize, proxy.size)
        }
    }
}
