//
//  CoreKit+CoreExtensions.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import UIKit

/* 3rd-party */
import AlertKit
import CoreArchitecture

extension CoreKit: AlertKit.PresentationDelegate {
    // MARK: - Properties

    public var frontmostAlertController: UIAlertController? {
        @Dependency(\.uiApplication.keyViewController) var viewController: UIViewController?
        return viewController as? UIAlertController
    }

    // MARK: - Methods

    public func present(_ alertController: UIAlertController) {
        ui.present(
            alertController,
            animated: true,
            embedded: false,
            forced: false
        )
    }
}
