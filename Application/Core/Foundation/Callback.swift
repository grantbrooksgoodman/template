//
//  Build.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

public enum Callback<Success, Failure> where Failure : Exceptionable {
    case success(Success)
    case failure(Failure)
}

public protocol Exceptionable {
    var descriptor: String! { get }
    var extraParams: [String: Any]? { get }
    var hashlet: String! { get }
    var isReportable: Bool! { get }
    var metadata: [Any]! { get }
    var metaID: String! { get }
    var underlyingExceptions: [Exception]? { get }
}
