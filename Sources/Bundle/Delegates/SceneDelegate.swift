//
//  SceneDelegate.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import UIKit

/* Proprietary */
import AppSubsystem

/// The delegate that manages the app's window scene lifecycle.
///
/// `SceneDelegate` creates and configures the root window when a
/// scene connects, and forwards trait collection changes to the
/// subsystem.
///
/// Per-scene setup occurs in ``scene(_:willConnectTo:options:)``,
/// which instantiates the root window scene and attaches the app's
/// root SwiftUI view hierarchy.
final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    // MARK: - Properties

    /// The window associated with this scene.
    var window: UIWindow?

    // MARK: - UIScene

    /// Creates the root window and attaches the app's view hierarchy.
    ///
    /// This method calls
    /// ``RootWindowScene/instantiate(_:rootView:)`` to build the
    /// window scene with ``RootView`` as its content.
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        window = RootWindowScene.instantiate(
            scene,
            rootView: RootView()
        )
    }

    // MARK: - UIWindowScene

    /// Notifies the subsystem when the trait collection changes.
    ///
    /// This method calls
    /// ``RootWindowScene/traitCollectionChanged()`` to propagate
    /// appearance changes – such as switching between light and dark
    /// mode – throughout the view hierarchy.
    func windowScene(
        _ windowScene: UIWindowScene,
        didUpdate previousCoordinateSpace: UICoordinateSpace,
        interfaceOrientation previousInterfaceOrientation:
        UIInterfaceOrientation,
        traitCollection previousTraitCollection: UITraitCollection
    ) {
        RootWindowScene.traitCollectionChanged()
    }
}
