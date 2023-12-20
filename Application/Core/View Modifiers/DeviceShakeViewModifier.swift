//
//  DeviceShakeViewModifier.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import SwiftUI
import UIKit

/* 3rd-party */
import Redux

private struct DeviceShakeViewModifier: ViewModifier {
    // MARK: - Dependencies

    @Dependency(\.notificationCenter) private var notificationCenter: NotificationCenter

    // MARK: - Properties

    public let action: () -> Void

    // MARK: - Init

    public init(action: @escaping () -> Void) {
        self.action = action
    }

    // MARK: - Body

    public func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(notificationCenter.publisher(for: UIDevice.deviceDidShakeNotification)) { _ in
                action()
            }
    }
}

private extension UIDevice {
    static let deviceDidShakeNotification = Notification.Name(rawValue: "deviceDidShakeNotification")
}

public extension UIWindow {
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        @Dependency(\.notificationCenter) var notificationCenter: NotificationCenter
        guard motion == .motionShake else { return }
        notificationCenter.post(name: UIDevice.deviceDidShakeNotification, object: nil)
    }
}

public extension View {
    func onShake(perform action: @escaping () -> Void) -> some View {
        modifier(DeviceShakeViewModifier(action: action))
    }
}
