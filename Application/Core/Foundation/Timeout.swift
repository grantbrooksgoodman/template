//
//  Timeout.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import CoreArchitecture

public final class Timeout {
    // MARK: - Dependencies

    @Dependency(\.coreKit.gcd) private var coreGCD: CoreKit.GCD

    // MARK: - Properties

    private var callback: (() -> Void)?
    private var isValid = true
    private var metadata: [Any]?

    // MARK: - Object Lifecycle

    public init(
        after duration: Duration,
        callback: @escaping () -> Void
    ) {
        self.callback = callback
        coreGCD.after(duration) {
            guard self.isValid else { return }
            self.invoke()
        }
    }

    public init(
        alertingAfter: Duration,
        metadata: [Any]
    ) {
        guard metadata.isValidMetadata else { fatalError("Improperly formatted metadata") }
        self.metadata = metadata
        coreGCD.after(alertingAfter) {
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
        Logger.log(.timedOut(metadata!), with: .errorAlert)
    }
}
