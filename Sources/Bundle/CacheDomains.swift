//
//  CacheDomains.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* Proprietary */
import AppSubsystem

extension CacheDomain {
    struct List: AppSubsystem.Delegates.CacheDomainListDelegate {
        let appCacheDomains: [CacheDomain] = []
    }
}
