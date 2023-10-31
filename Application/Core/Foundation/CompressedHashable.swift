//
//  CompressedHashable.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import CryptoKit
import Foundation

/* 3rd-party */
import Redux

public protocol CompressedHashable {
    var hashFactors: [String] { get }
}

public extension CompressedHashable {
    var compressedHash: String {
        @Dependency(\.jsonEncoder) var jsonEncoder: JSONEncoder
        do {
            return try jsonEncoder.encode(hashFactors).compressedHash
        } catch {
            Logger.log(.init(error, metadata: [self, #file, #function, #line]))
            return Data().compressedHash
        }
    }
}

private extension Data {
    var compressedHash: String {
        guard let compressedData = try? (self as NSData).compressed(using: .lzfse) else {
            return SHA256.hash(data: self).compactMap { String(format: "%02x", $0) }.joined()
        }

        return SHA256.hash(data: compressedData).compactMap { String(format: "%02x", $0) }.joined()
    }
}
