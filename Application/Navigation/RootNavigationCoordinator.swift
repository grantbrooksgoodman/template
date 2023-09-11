//
//  RootNavigationCoordinator.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

public class RootNavigationCoordinator: ObservableObject {
    @Published var page: RootPage = .sample
}

public enum RootPage {
    case sample
}
