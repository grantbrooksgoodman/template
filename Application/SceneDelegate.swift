//
//  SceneDelegate.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import SwiftUI
import UIKit

/* 3rd-party */
import Redux

public final class SceneDelegate: UIResponder, UIWindowSceneDelegate, UIGestureRecognizerDelegate {
    // MARK: - Properties

    // Timer
    private var touchTimer: Timer?

    // UIWindow
    public var window: UIWindow?

    // MARK: - Computed Properties

    private var buildInfoOverlayWindow: UIWindow? {
        @Dependency(\.uiApplication.keyWindow) var keyWindow: UIWindow?
        return keyWindow?.firstSubview(for: "BUILD_INFO_OVERLAY_WINDOW") as? UIWindow
    }

    // MARK: - UIScene

    public func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        @Dependency(\.build) var build: Build
        @Dependency(\.coreKit.ui) var coreUI: CoreKit.UI

        // Create the SwiftUI view that provides the window contents.
        let contentView = RootView()

        // Use a UIHostingController as window root view controller.
        guard let windowScene = scene as? UIWindowScene else { return }

        let keyWindow = UIWindow(windowScene: windowScene)
        keyWindow.rootViewController = UIHostingController(rootView: contentView)
        keyWindow.makeKeyAndVisible()
        window = keyWindow

        guard build.stage != .generalRelease else { return }

        let tapGesture = UITapGestureRecognizer(target: self, action: nil)
        tapGesture.delegate = self

        let bounds = keyWindow.screen.bounds

        let buildInfoOverlayWindow = PassthroughWindow()
        buildInfoOverlayWindow.frame = CGRect(
            x: 0,
            y: bounds.maxY - 100,
            width: bounds.size.width,
            height: 100
        )

        let buildInfoOverlayView = BuildInfoOverlayView(.init(initialState: .init(), reducer: BuildInfoOverlayReducer()))
        buildInfoOverlayWindow.rootViewController = UIHostingController(rootView: buildInfoOverlayView)

        buildInfoOverlayWindow.isHidden = false
        buildInfoOverlayWindow.tag = coreUI.semTag(for: "BUILD_INFO_OVERLAY_WINDOW")

        keyWindow.addGestureRecognizer(tapGesture)
        keyWindow.addSubview(buildInfoOverlayWindow)

        let rootWindow = PassthroughWindow(windowScene: windowScene)
        let rootView = RootWindow(.init(initialState: .init(), reducer: RootReducer()))
        rootWindow.rootViewController = UIHostingController(rootView: rootView)

        rootWindow.isHidden = false
        rootWindow.tag = coreUI.semTag(for: "ROOT_WINDOW")

        keyWindow.addSubview(rootWindow)

        defer {
            buildInfoOverlayWindow.backgroundColor = .clear
            buildInfoOverlayWindow.rootViewController?.view.backgroundColor = .clear

            rootWindow.backgroundColor = .clear
            rootWindow.rootViewController?.view.backgroundColor = .clear
        }

        @Persistent(.hidesBuildInfoOverlay) var hidesBuildInfoOverlay: Bool?
        if let shouldHide = hidesBuildInfoOverlay,
           shouldHide {
            guard build.developerModeEnabled else {
                hidesBuildInfoOverlay = false
                return
            }

            buildInfoOverlayWindow.isHidden = shouldHide
        }

        if build.expiryDate.comparator == Date().comparator,
           build.timebombActive {
            let expiryOverlayWindow = UIWindow()
            expiryOverlayWindow.frame = CGRect(
                x: 0,
                y: 0,
                width: bounds.size.width,
                height: bounds.size.height
            )
            expiryOverlayWindow.rootViewController = UIHostingController(rootView: ExpiryOverlayView())
            expiryOverlayWindow.isHidden = false
            expiryOverlayWindow.tag = coreUI.semTag(for: "EXPIRY_OVERLAY_WINDOW")

            keyWindow.addSubview(expiryOverlayWindow)
        }
    }

    public func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    public func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    public func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    public func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    public func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    // MARK: - UIWindowScene

    public func windowScene(
        _ windowScene: UIWindowScene,
        didUpdate previousCoordinateSpace: UICoordinateSpace,
        interfaceOrientation previousInterfaceOrientation:
        UIInterfaceOrientation,
        traitCollection previousTraitCollection: UITraitCollection
    ) {
        Observables.themedViewAppearanceChanged.trigger()
    }

    // MARK: - UIGestureRecognizer

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        touchTimer?.invalidate()
        touchTimer = nil

        UIView.animate(withDuration: 0.2) {
            self.buildInfoOverlayWindow?.alpha = 0.35
        } completion: { _ in
            guard self.touchTimer == nil else { return }
            self.touchTimer = .scheduledTimer(
                timeInterval: 5,
                target: self,
                selector: #selector(self.touchTimerAction),
                userInfo: nil,
                repeats: true
            )
        }

        return false
    }

    @objc
    private func touchTimerAction() {
        guard touchTimer != nil else { return }
        touchTimer?.invalidate()
        touchTimer = nil

        UIView.animate(withDuration: 0.2) {
            self.buildInfoOverlayWindow?.alpha = 1
        }
    }
}
