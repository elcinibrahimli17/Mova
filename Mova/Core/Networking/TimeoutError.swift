//
//  TimeoutError.swift
//  Mova
//
//  Created by Elchın on 17.09.26.
//

import Foundation

enum TimeoutError: Error {
    case timedOut
}

func withTimeout<T: Sendable>(
    seconds: TimeInterval,
    operation: @escaping @Sendable () async throws -> T
) async throws -> T {
    try await withThrowingTaskGroup(of: T.self) { group in
        group.addTask {
            try await operation()
        }
        group.addTask {
            try await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
            throw TimeoutError.timedOut
        }
        guard let result = try await group.next() else {
            throw TimeoutError.timedOut
        }
        group.cancelAll()
        return result
    }
}
