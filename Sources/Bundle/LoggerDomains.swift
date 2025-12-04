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

extension LoggerDomain {
    struct SubscriptionDelegate: AppSubsystem.Delegates.LoggerDomainSubscriptionDelegate {
        let domainsExcludedFromSessionRecord: [LoggerDomain] = [
            .observer,
        ]

        let subscribedDomains: [LoggerDomain] = [
            .alertKit,
            .caches,
            .general,
            .translation,
        ]
    }
}
