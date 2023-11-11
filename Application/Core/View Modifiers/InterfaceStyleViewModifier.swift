//
//  InterfaceStyleViewModifier.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import SwiftUI

/* 3rd-party */
import Redux

private struct InterfaceStyleViewModifier: ViewModifier {
    // MARK: - Dependencies

    @Dependency(\.coreKit) private var core: CoreKit
    @Dependency(\.uiApplication) private var uiApplication: UIApplication

    // MARK: - Properties

    private let interfaceStyle: UIUserInterfaceStyle

    // MARK: - Init

    public init(_ interfaceStyle: UIUserInterfaceStyle) {
        self.interfaceStyle = interfaceStyle
    }

    // MARK: - Body

    func body(content: Content) -> some View {
        content
            .onAppear { overrideStyle() }
    }

    // MARK: - Auxiliary Methods

    private func overrideStyle() {
        guard uiApplication.applicationState == .active else {
            core.gcd.after(.milliseconds(10)) { overrideStyle() }
            return
        }

        guard uiApplication.interfaceStyle != interfaceStyle else { return }
        core.ui.overrideUserInterfaceStyle(interfaceStyle)

        core.gcd.after(.milliseconds(10)) {
            guard uiApplication.interfaceStyle != interfaceStyle else { return }
            overrideStyle()
        }
    }
}

public extension View {
    func interfaceStyle(_ interfaceStyle: UIUserInterfaceStyle) -> some View {
        modifier(InterfaceStyleViewModifier(interfaceStyle))
    }
}
