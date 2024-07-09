//
//  Exception+CoreExtensions.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import AlertKit

extension Exception: AlertKit.Errorable {
    public var description: String {
        get { userFacingDescriptor }
        set { descriptor = newValue }
    }

    public var id: String { "\(hashlet!)\(metaID!)".lowercased() }
}

public extension Exception {
    init(_ error: Error?, metadata: [Any]) {
        guard let error else {
            self.init(metadata: metadata)
            return
        }

        self.init(error, metadata: metadata)
    }

    static func internetConnectionOffline(_ metadata: [Any]) -> Exception {
        .init(
            "Internet connection is offline.",
            isReportable: false,
            extraParams: [CommonParamKeys.userFacingDescriptor.rawValue: Localized(.internetConnectionOffline).wrappedValue],
            metadata: metadata
        )
    }

    static func timedOut(_ metadata: [Any]) -> Exception {
        .init(
            "The operation timed out. Please try again later.",
            isReportable: false,
            extraParams: [CommonParamKeys.userFacingDescriptor.rawValue: Localized(.timedOut).wrappedValue],
            metadata: metadata
        )
    }
}
