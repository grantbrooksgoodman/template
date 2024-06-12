//
//  RootWindowService.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import UIKit

/* 3rd-party */
import CoreArchitecture

public struct RootWindowService {
    public func startRaisingWindow() {
        @Dependency(\.coreKit) var core: CoreKit
        @Dependency(\.uiApplication.keyWindow) var keyWindow: UIWindow?

        defer {
            core.gcd.after(.milliseconds(50)) { startRaisingWindow() }
        }

        guard let keyWindow,
              let rootWindow = keyWindow.subviews.first(where: { $0.tag == core.ui.semTag(for: "ROOT_WINDOW") }),
              keyWindow.subviews.last != rootWindow else { return }

        keyWindow.bringSubviewToFront(rootWindow)
    }
}
