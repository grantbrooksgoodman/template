//
//  LoggerDomains.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* Proprietary */
import AppSubsystem

public extension LoggerDomain {
    static let domainsExcludedFromSessionRecord: [LoggerDomain] = [
        .observer,
    ]

    static let subscribedDomains: [LoggerDomain] = [
        .alertKit,
        .caches,
        .general,
        .translation,
    ]
}
