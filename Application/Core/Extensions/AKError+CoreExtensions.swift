//
//  AKError+CoreExtensions.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import AlertKit

public extension AKError {
    init(_ exception: Exception) {
        let descriptor = exception.userFacingDescriptor
        var params: [String: Any] = ["Descriptor": exception.descriptor,
                                     "Hashlet": exception.hashlet!]

        if let extraParams = exception.extraParams,
           !extraParams.isEmpty {
            extraParams.forEach { params[$0.key] = $0.value }
        }

        if let underlyingExceptions = exception.underlyingExceptions,
           !underlyingExceptions.isEmpty {
            params["UnderlyingExceptions"] = underlyingExceptions.referenceCodes
        }

        self.init(
            descriptor,
            isReportable: exception.isReportable,
            extraParams: params.withCapitalizedKeys,
            metadata: exception.metadata
        )
    }

    func injecting(_ parameters: [String: Any]) -> AKError {
        var mutable = self

        guard var existingParams = mutable.extraParams else {
            mutable.extraParams = parameters
            return mutable
        }

        parameters.forEach { existingParams[$0.key] = $0.value }
        mutable.extraParams = existingParams
        return mutable
    }
}
