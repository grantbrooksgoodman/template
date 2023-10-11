//
//  Timeout.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* 3rd-party */
import AlertKit
import Redux

public final class Timeout {
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
        coreGCD.after(after) {
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
        
        AKErrorAlert(
            error: .init(.timedOut(metadata!)),
            shouldTranslate: [build.isOnline ? .actions(indices: nil) : .none]
        ).present()
    }
}
