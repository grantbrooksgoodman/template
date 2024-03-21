//
//  View+CoreExtensions.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import SwiftUI

public extension View {
    func onReceive(
        _ name: Notification.Name,
        center: NotificationCenter = .default,
        object: AnyObject? = nil,
        perform action: @escaping (Notification) -> Void
    ) -> some View {
        onReceive(
            center.publisher(for: name, object: object),
            perform: action
        )
    }

    func onTraitCollectionChange(perform action: @escaping () -> Void) -> some View {
        onReceive(.traitCollectionChangedNotification) { _ in
            action()
        }
    }
}
