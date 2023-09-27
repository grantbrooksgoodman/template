//
//  Timeout.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* 3rd-party */
import AlertKit
import Redux

public class Timeout {
    // MARK: - Dependencies

    @Dependency(\.build) private var build: Build
    @Dependency(\.coreKit.gcd) private var coreGCD: CoreKit.GCD

    // MARK: - Properties

    private var callback: (() -> Void)?
    private var isValid = true
    private var metadata: [Any]?

    // MARK: - Object Lifecycle

    public init(
        after: Duration,
        _ callback: @escaping () -> Void = {}
    ) {
        self.callback = callback
        coreGCD.after(seconds: .init(after.components.seconds)) {
            guard self.isValid else { return }
            self.invoke()
        }
    }

    public init(
        alertingAfter: Duration,
        metadata: [Any]
    ) {
        self.metadata = metadata
        coreGCD.after(seconds: .init(alertingAfter.components.seconds)) {
            guard self.isValid else { return }
            self.presentTimeoutAlert()
        }
    }

    deinit {
        cancel()
    }

    // MARK: - Cancellation

    public func cancel() {
        callback = nil
        isValid = false
    }

    // MARK: - Auxiliary

    private func invoke() {
        callback?()
        cancel()
    }

    private func presentTimeoutAlert() {
        cancel()

        AKErrorAlert(
            error: .init(.timedOut(metadata!)),
            shouldTranslate: [build.isOnline ? .actions(indices: nil) : .none]
        ).present()
    }
}
