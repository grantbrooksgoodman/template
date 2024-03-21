//
//  StatusBarStyleViewModifier.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import SwiftUI

/* 3rd-party */
import Redux

private struct StatusBarStyleViewModifier: ViewModifier {
    // MARK: - Dependencies

    @Dependency(\.coreKit.ui) private var coreUI: CoreKit.UI
    @Dependency(\.uiApplication.keyWindow?.windowScene) private var windowScene: UIWindowScene?

    // MARK: - Properties

    // UIStatusBarStyle
    private let preferredStatusBarStyle: UIStatusBarStyle

    // Other
    @SwiftUI.Environment(\.isPresented) private var isPresented: Bool
    private var statusBarWindow: UIWindow?

    // MARK: - Computed Properties

    private var defaultStatusBarStyle: UIStatusBarStyle { ThemeService.isDarkModeActive ? .lightContent : .darkContent }
    private var statusBarViewController: StatusBarViewController? { statusBarWindow?.rootViewController as? StatusBarViewController }

    // MARK: - Init

    public init(style: UIStatusBarStyle) {
        preferredStatusBarStyle = style
        let existingWindow = windowScene?.windows.first(where: { $0.tag == coreUI.semTag(for: "STATUS_BAR_WINDOW") })
        statusBarWindow = existingWindow ?? createStatusBarWindow()
        statusBarViewController?.statusBarStyle = preferredStatusBarStyle
    }

    // MARK: - Body

    public func body(content: Content) -> some View {
        content
            .onAppear {
                statusBarViewController?.statusBarStyle = preferredStatusBarStyle
            }
            .onDisappear {
                guard isPresented else { return }
                statusBarViewController?.statusBarStyle = defaultStatusBarStyle
            }
            .onTraitCollectionChange {
                statusBarViewController?.statusBarStyle = isPresented ? preferredStatusBarStyle : defaultStatusBarStyle
            }
    }

    // MARK: - Auxiliary

    private func createStatusBarWindow() -> UIWindow? {
        guard let windowScene else { return nil }

        let statusBarWindow: UIWindow = .init(windowScene: windowScene)

        statusBarWindow.isHidden = false
        statusBarWindow.isUserInteractionEnabled = false

        statusBarWindow.rootViewController = StatusBarViewController()
        statusBarWindow.tag = coreUI.semTag(for: "STATUS_BAR_WINDOW")
        statusBarWindow.windowLevel = .statusBar

        return statusBarWindow
    }
}

public extension View {
    func preferredStatusBarStyle(_ style: UIStatusBarStyle) -> some View {
        modifier(StatusBarStyleViewModifier(style: style))
    }
}

private class StatusBarViewController: UIViewController {
    // MARK: - Properties

    public var statusBarStyle: UIStatusBarStyle = .default {
        didSet { setNeedsStatusBarAppearanceUpdate() }
    }

    // MARK: - Computed Properties

    override public var preferredStatusBarStyle: UIStatusBarStyle { statusBarStyle }

    // MARK: - Init

    public init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
