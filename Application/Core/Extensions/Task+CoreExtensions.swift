//
//  Task+CoreExtensions.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

public extension Task where Failure == Error {
    @discardableResult
    static func background(
        delayedBy duration: Duration = .zero,
        @_implicitSelfCapture operation: @escaping @Sendable () async throws -> Success
    ) -> Task {
        Task(priority: .background) {
            guard duration != .zero else { return try await operation() }
            try await Task<Never, Never>.sleep(nanoseconds: .init(duration.timeInterval * 1_000_000_000))
            return try await operation()
        }
    }

    @discardableResult
    static func delayed(
        by duration: Duration,
        priority: TaskPriority? = nil,
        @_implicitSelfCapture operation: @escaping @Sendable () async throws -> Success
    ) -> Task {
        Task(priority: priority) {
            try await Task<Never, Never>.sleep(nanoseconds: .init(duration.timeInterval * 1_000_000_000))
            return try await operation()
        }
    }
}
