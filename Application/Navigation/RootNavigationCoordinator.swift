//
//  RootNavigationCoordinator.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

public enum RootPage {
    case sample
}

public class RootNavigationCoordinator: ObservableObject {
    // MARK: - Properties

    @Published public private(set) var page: RootPage = .sample

    // MARK: - Methods

    public func setPage(_ page: RootPage) {
        self.page = page
    }
}
