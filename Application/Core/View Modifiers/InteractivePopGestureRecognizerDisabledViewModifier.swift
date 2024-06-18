//
//  InteractivePopGestureRecognizerDisabledViewModifier.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import SwiftUI
import UIKit

/* 3rd-party */
import CoreArchitecture

public enum InteractivePopGestureRecognizer {
    // MARK: - Properties

    public private(set) static var isEnabled = true

    // MARK: - Set Is Enabled

    public static func setIsEnabled(_ isEnabled: Bool) {
        @Dependency(\.uiApplication) var uiApplication: UIApplication
        guard uiApplication.applicationState == .active else { return }
        self.isEnabled = isEnabled
    }
}

// swiftlint:disable:next type_name
private struct InteractivePopGestureRecognizerDisabledViewModifier: ViewModifier {
    // MARK: - Properties

    private let isDisabled: Bool

    @State private var initialValue = InteractivePopGestureRecognizer.isEnabled

    // MARK: - Init

    public init(_ isDisabled: Bool) {
        self.isDisabled = isDisabled
    }

    // MARK: - Body

    public func body(content: Content) -> some View {
        content
            .onAppear { InteractivePopGestureRecognizer.setIsEnabled(!isDisabled) }
            .onChange(of: isDisabled) { InteractivePopGestureRecognizer.setIsEnabled(!$0) }
            .onDisappear { InteractivePopGestureRecognizer.setIsEnabled(initialValue) }
    }
}

public extension View {
    func interactivePopGestureRecognizerDisabled(_ isDisabled: Bool = true) -> some View {
        modifier(InteractivePopGestureRecognizerDisabledViewModifier(isDisabled))
    }
}
