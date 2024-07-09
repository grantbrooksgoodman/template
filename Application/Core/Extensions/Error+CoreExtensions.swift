//
//  Error+CoreExtensions.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

public extension Error {
    var staticIdentifier: String {
        let nsError = self as NSError
        var underlyingIDs = ["[\(nsError.domain):\(nsError.code)]"]
        underlyingIDs.append(contentsOf: nsError.underlyingErrors.reduce(into: [String]()) { partialResult, error in
            let underlyingNSError = error as NSError
            partialResult.append("[\(underlyingNSError.domain):\(underlyingNSError.code)]")
        })
        return underlyingIDs.joined(separator: "+")
    }
}
