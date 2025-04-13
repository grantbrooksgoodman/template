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
import Networking

public extension LoggerDomain {
    struct SubscriptionDelegate: AppSubsystem.Delegates.LoggerDomainSubscriptionDelegate {
        public let domainsExcludedFromSessionRecord: [LoggerDomain] = [
            .observer,
        ]

        public let subscribedDomains: [LoggerDomain] = [
            .alertKit,
            .caches,
            .general,
            .Networking.database,
            .Networking.hostedTranslation,
            .Networking.storage,
            .translation,
        ]
    }
}
