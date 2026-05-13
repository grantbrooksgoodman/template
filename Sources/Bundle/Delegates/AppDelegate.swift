//
//  AppDelegate.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import UIKit

/// The app's main entry point and application lifecycle delegate.
///
/// `AppDelegate` initializes the subsystem when the app
/// launches.
///
@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: - UIApplication

    /// Performs one-time application setup at launch.
    ///
    /// This method calls ``Application/initialize()`` to register all
    /// app-level delegates and configure the subsystem before any
    /// scenes connect.
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        Application.initialize()
        return true
    }
}
