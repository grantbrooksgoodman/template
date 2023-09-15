//
//  Timeout.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* 3rd-party */
import AlertKit

public class Timeout {
    // MARK: - Properties

    private var callback: (() -> Void)?
    private var metadata: [Any]?
    private var timer: Timer?

    // MARK: - Object Lifecycle

    public init(
        after: Double,
        _ callback: @escaping () -> Void = {}
    ) {
        self.callback = callback

        timer = Timer.scheduledTimer(
            timeInterval: after,
            target: self,
            selector: #selector(invoke),
            userInfo: nil,
            repeats: false
        )
    }

    public init(
        alertingAfter: Double,
        metadata: [Any],
        _ callback: @escaping () -> Void = {}
    ) {
        self.callback = callback
        self.metadata = metadata
        timer = Timer.scheduledTimer(
            timeInterval: alertingAfter,
            target: self,
            selector: #selector(presentTimeoutAlert),
            userInfo: nil,
            repeats: false
        )
    }

    deinit {
        cancel()
    }

    // MARK: - Cancellation

    public func cancel() {
        timer?.invalidate()
        timer = nil
    }

    // MARK: - Auxiliary

    @objc private func invoke() {
        callback?()

        // Discard callback and timer.
        callback = nil
        timer = nil
    }

    @objc private func presentTimeoutAlert() {
        callback?()

        AKErrorAlert(
            error: Exception.timedOut(metadata!).asAkError(),
            shouldTranslate: [Build.isOnline ? .actions(indices: nil) : .none]
        ).present()
    }
}
