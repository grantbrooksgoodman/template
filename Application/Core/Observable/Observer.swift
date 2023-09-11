//
//  Observer.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

public protocol Observer {
    var type: ObserverType { get }
    func onChange(of observable: Observable<Any>)
}
