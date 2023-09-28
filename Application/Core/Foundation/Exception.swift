//
//  Exception.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import CryptoKit

/* 3rd-party */
import AlertKit

public struct Exception: Equatable, Exceptionable {
    // MARK: - Types

    public enum CommonParamKeys: String {
        case userFacingDescriptor = "UserFacingDescriptor"
    }

    // MARK: - Properties

    // Array
    public var metadata: [Any]!
    public var underlyingExceptions: [Exception]?

    // String
    public var descriptor: String!
    public var hashlet: String!
    public var metaID: String!

    // Other
    public var extraParams: [String: Any]?
    public var isReportable: Bool!

    // MARK: - Init

    public init(
        _ descriptor: String? = nil,
        isReportable: Bool? = nil,
        extraParams: [String: Any]? = nil,
        underlyingExceptions: [Exception]? = nil,
        metadata: [Any]
    ) {
        guard metadata.isValidMetadata else { fatalError("Improperly formatted metadata") }

        self.descriptor = descriptor ?? "An unknown error occurred."
        self.isReportable = isReportable ?? true
        self.extraParams = extraParams
        self.metadata = metadata

        hashlet = getHashlet(for: self.descriptor)
        metaID = getMetaID(for: metadata)

        // #warning("Is the self filter necessary?")
        self.underlyingExceptions = underlyingExceptions?.unique().filter { $0 != self }
    }

    public init(
        _ error: Error,
        isReportable: Bool? = nil,
        extraParams: [String: Any]? = nil,
        underlyingExceptions: [Exception]? = nil,
        metadata: [Any]
    ) {
        self.init(
            error as NSError,
            isReportable: isReportable,
            extraParams: extraParams,
            underlyingExceptions: underlyingExceptions,
            metadata: metadata
        )
    }

    public init(
        _ error: NSError,
        isReportable: Bool? = nil,
        extraParams: [String: Any]? = nil,
        underlyingExceptions: [Exception]? = nil,
        metadata: [Any]
    ) {
        guard metadata.isValidMetadata else { fatalError("Improperly formatted metadata") }

        descriptor = error.localizedDescription
        self.isReportable = isReportable ?? true
        self.metadata = metadata

        var params: [String: Any] = error.userInfo.filter { $0.key != "NSLocalizedDescription" }
        params["NSErrorCode"] = error.code
        params["NSErrorDomain"] = error.domain

        if let extraParams = extraParams,
           !extraParams.isEmpty {
            extraParams.forEach { param in
                if param.key != "NSLocalizedDescription" {
                    params[param.key] = param.value
                }
            }
        }

        self.extraParams = params.withCapitalizedKeys

        hashlet = getHashlet(for: error.staticIdentifier)
        metaID = getMetaID(for: metadata)

        self.underlyingExceptions = underlyingExceptions?.unique().filter { $0 != self }
    }

    // MARK: - Append

    public func appending(extraParams: [String: Any]) -> Exception {
        guard let currentParams = self.extraParams,
              !currentParams.isEmpty else {
            return .init(
                descriptor,
                isReportable: isReportable,
                extraParams: extraParams.withCapitalizedKeys,
                metadata: metadata
            )
        }

        var params: [String: Any] = currentParams
        extraParams.forEach { param in
            params[param.key] = param.value
        }

        return .init(
            descriptor,
            isReportable: isReportable,
            extraParams: params.withCapitalizedKeys,
            metadata: [#file, #function, #line]
        )
    }

    public func appending(underlyingException: Exception) -> Exception {
        guard let currentUnderlyingExceptions = underlyingExceptions,
              !currentUnderlyingExceptions.isEmpty else {
            return .init(
                descriptor,
                isReportable: isReportable,
                extraParams: extraParams,
                underlyingExceptions: [underlyingException],
                metadata: metadata
            )
        }

        var exceptions = currentUnderlyingExceptions
        exceptions.append(underlyingException)

        return .init(
            descriptor,
            isReportable: isReportable,
            extraParams: extraParams,
            underlyingExceptions: exceptions,
            metadata: metadata
        )
    }

    // MARK: - Auxiliary

    private func getHashlet(for descriptor: String) -> String {
        var hashlet = ""

        let stripWords = ["a", "an", "is", "that", "the", "this", "was"]
        for word in descriptor.components(separatedBy: " ") where !stripWords.contains(word.lowercased()) {
            hashlet.append("\(word)\(word.lowercased() == "not" ? "" : " ")")
        }

        let alphabetSet = Set("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz")
        hashlet = hashlet.filter { alphabetSet.contains($0) }

        hashlet = hashlet.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        hashlet = hashlet.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\u{00A0}", with: "")

        let compressedData = try? (Data(hashlet.utf8) as NSData).compressed(using: .lzfse)
        if let data = compressedData {
            hashlet = SHA256.hash(data: data).compactMap { String(format: "%02x", $0) }.joined()
        } else {
            hashlet = SHA256.hash(data: Data(hashlet.utf8)).compactMap { String(format: "%02x", $0) }.joined()
        }

        let count = hashlet.components.count
        let prefix = hashlet.components[0 ... 1]
        let suffix = hashlet.components[count - 2 ... count - 1]

        return "\(prefix.joined())\(suffix.joined())".uppercased()
    }

    private func getMetaID(for metadata: [Any]) -> String {
        // swiftlint:disable force_cast
        let unformattedFileName = metadata[0] as! String
        let fileName = unformattedFileName.components(separatedBy: "/").last!.components(separatedBy: ".")[0]
        let lineNumber = metadata[2] as! Int
        // swiftlint:enable force_cast

        var hexChars = fileName.reduce(into: [String]()) { partialResult, character in
            if let asciiValue = character.asciiValue {
                partialResult.append(.init(format: "%02X", asciiValue))
            }
        }

        if hexChars.count > 3 {
            var subsequence = Array(hexChars[0 ... 3])
            subsequence.append(hexChars.last!)
            hexChars = subsequence
        }

        return "\(hexChars.joined(separator: ""))x\(lineNumber)".lowercased()
    }

    // MARK: - Equatable Conformance

    public static func == (lhs: Exception, rhs: Exception) -> Bool {
        let leftMetaID = lhs.metaID
        let leftHashlet = lhs.hashlet
        let leftDescriptor = lhs.descriptor
        let leftIsReportable = lhs.isReportable
        let leftUnderlyingExceptions = lhs.underlyingExceptions
        let leftAllUnderlyingExceptions = lhs.allUnderlyingExceptions()

        let rightMetaID = rhs.metaID
        let rightHashlet = rhs.hashlet
        let rightDescriptor = rhs.descriptor
        let rightIsReportable = rhs.isReportable
        let rightUnderlyingExceptions = rhs.underlyingExceptions
        let rightAllUnderlyingExceptions = rhs.allUnderlyingExceptions()

        var leftStringBasedParams = [String: String]()
        lhs.extraParams?.forEach { parameter in
            if let stringValue = parameter.value as? String {
                leftStringBasedParams[parameter.key] = stringValue
            }
        }

        var rightStringBasedParams = [String: String]()
        rhs.extraParams?.forEach { parameter in
            if let stringValue = parameter.value as? String {
                rightStringBasedParams[parameter.key] = stringValue
            }
        }

        let leftNonStringBasedParamsCount = (lhs.extraParams?.count ?? 0) - leftStringBasedParams.count
        let rightNonStringBasedParamsCount = (rhs.extraParams?.count ?? 0) - rightStringBasedParams.count

        guard leftMetaID == rightMetaID,
              leftHashlet == rightHashlet,
              leftDescriptor == rightDescriptor,
              leftIsReportable == rightIsReportable,
              leftUnderlyingExceptions == rightUnderlyingExceptions,
              leftAllUnderlyingExceptions == rightAllUnderlyingExceptions,
              leftStringBasedParams == rightStringBasedParams,
              leftNonStringBasedParamsCount == rightNonStringBasedParamsCount else { return false }

        return true
    }
}

public extension AKError {
    init(_ exception: Exception) {
        let descriptor = exception.userFacingDescriptor
        var params: [String: Any] = ["Descriptor": exception.descriptor!,
                                     "Hashlet": exception.hashlet!]

        if let extraParams = exception.extraParams,
           !extraParams.isEmpty {
            extraParams.forEach { param in
                params[param.key] = param.value
            }
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
}

public extension Array where Element == Exception {
    // MARK: - Properties

    /**
     Returns a single **Exception** from an array of **Exceptions** by appending each as underlying **Exceptions** to the final item in the array.
     */
    var compiledException: Exception? {
        guard !isEmpty else { return nil }
        var finalException = last!
        guard count > 1 else { return finalException }

        Array(reversed()[1 ... count - 1]).unique().forEach { exception in
            finalException = finalException.appending(underlyingException: exception)
        }

        return finalException
    }

    /**
     Returns an array of identifier strings for each **Exception** in the array.
     */
    var referenceCodes: [String] {
        var codes = [String]()

        for (index, exception) in enumerated() {
            let suffix = codes.contains(where: { $0.hasPrefix(exception.hashlet!.lowercased()) }) ? "x\(index)" : ""
            codes.append("\(exception.hashlet!)x\(exception.metaID!)\(suffix)".lowercased())

            exception.allUnderlyingExceptions().enumerated().forEach { index, underlyingException in
                let suffix = codes.contains(where: { $0.hasPrefix(underlyingException.hashlet!.lowercased()) }) ? "x\(index)" : ""
                codes.append("\(underlyingException.hashlet!)x\(underlyingException.metaID!)\(suffix)".lowercased())
            }
        }

        return codes
    }

    // MARK: - Methods

    func unique() -> [Exception] {
        var uniqueValues = [Exception]()

        for value in self where !uniqueValues.contains(where: { $0 == value }) {
            uniqueValues.append(value)
        }

        return uniqueValues
    }
}

public extension Error {
    var staticIdentifier: String {
        let nsError = self as NSError

        var underlyingIDs = ["[\(nsError.domain):\(nsError.code)]"]
        for error in nsError.underlyingErrors {
            let underlyingNsError = error as NSError
            underlyingIDs.append("[\(underlyingNsError.domain):\(underlyingNsError.code)]")
        }

        return underlyingIDs.joined(separator: "+")
    }
}

public extension Exception {
    // #warning("This is better, but might still be wonky. Think about the recursion...")
    func allUnderlyingExceptions(_ with: [Exception]? = nil) -> [Exception] {
        var allExceptions = [Exception]()

        if let underlying = underlyingExceptions {
            allExceptions = underlying

            for exception in underlying {
                allExceptions.append(contentsOf: exception.allUnderlyingExceptions(allExceptions))
            }
        }

        return allExceptions.unique()
    }

    static func timedOut(_ metadata: [Any]) -> Exception {
        @Localized(.timedOut) var timedOutString: String
        let exception = Exception(
            "The operation timed out. Please try again later.",
            isReportable: false,
            extraParams: [CommonParamKeys.userFacingDescriptor.rawValue: timedOutString],
            metadata: metadata
        )
        return exception
    }
}
