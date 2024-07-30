//
//  Build.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import CoreArchitecture

public final class Build {
    // MARK: - Types

    public enum Stage: String {
        /* MARK: Cases */

        case preAlpha = "pre-alpha" /* Typically builds 0-1500. */
        case alpha /* Typically builds 1500-3000. */
        case beta /* Typically builds 3000-6000. */
        case releaseCandidate = "release candidate" /* Typically builds 6000 onwards. */
        case generalRelease = "general"

        /* MARK: Properties */

        public var shortString: String {
            switch self {
            case .preAlpha:
                return "p"
            case .alpha:
                return "a"
            case .beta:
                return "b"
            case .releaseCandidate:
                return "c"
            case .generalRelease:
                return "g"
            }
        }
    }

    // MARK: - Dependencies

    @Dependency(\.buildSKUDateFormatter) private var buildSKUDateFormatter: DateFormatter
    @Dependency(\.currentCalendar) private var calendar: Calendar
    @Dependency(\.expiryInfoStringDateFormatter) private var expiryInfoStringDateFormatter: DateFormatter
    @Dependency(\.mainBundle) private var mainBundle: Bundle
    @Dependency(\.projectIDDateFormatter) private var projectIDDateFormatter: DateFormatter

    // MARK: - Properties

    // Bool
    public private(set) var developerModeEnabled: Bool
    public private(set) var loggingEnabled: Bool
    public private(set) var timebombActive: Bool

    // String
    public let codeName: String
    public let dmyFirstCompileDateString: String
    public let finalName: String

    // Other
    public let appStoreReleaseVersion: Int
    public let stage: Stage

    // MARK: - Computed Properties

    // Int
    public var buildNumber: Int { getBuildNumber() }
    public var releaseBuildNumber: Int { getReleaseBuildNumber() }

    // String
    public var buildSKU: String { getBuildSKU() }
    public var bundleReleaseVersion: String { getBundleReleaseVersion() }
    public var bundleVersion: String { getBundleVersion() }
    public var expirationOverrideCode: String { getExpirationOverrideCode() }
    public var expiryInfoString: String { getExpiryInfoString() }
    public var projectID: String { getProjectID() }

    private var isReleaseBuild: Bool { getIsReleaseBuild() }

    // Other
    public var expiryDate: Date { getExpiryDate() }
    public var isOnline: Bool { getNetworkStatus() }

    private var buildDateUnixDouble: TimeInterval {
        guard let cfBuildDate = infoDictionary["CFBuildDate"] as? String else { return .init() }
        guard cfBuildDate != "1183100400" else {
            return .init(String(Date().timeIntervalSince1970).components(separatedBy: ".")[0]) ?? .init()
        }

        return .init(cfBuildDate) ?? .init()
    }

    private var infoDictionary: [String: Any] { mainBundle.infoDictionary ?? [:] }

    // MARK: - Init

    public init(
        appStoreReleaseVersion: Int,
        codeName: String,
        developerModeEnabled: Bool,
        dmyFirstCompileDateString: String,
        finalName: String,
        loggingEnabled: Bool,
        stage: Stage,
        timebombActive: Bool
    ) {
        self.appStoreReleaseVersion = appStoreReleaseVersion
        self.codeName = codeName
        self.developerModeEnabled = developerModeEnabled
        self.dmyFirstCompileDateString = dmyFirstCompileDateString
        self.finalName = finalName
        self.loggingEnabled = loggingEnabled
        self.stage = stage
        self.timebombActive = timebombActive
    }

    // MARK: - Setters

    public func setDeveloperModeEnabled(to value: Bool) {
        developerModeEnabled = value
    }

    public func setLoggingEnabled(to value: Bool) {
        loggingEnabled = value
    }

    public func setTimebombActive(to value: Bool) {
        timebombActive = value
    }

    // MARK: - Computed Property Getters

    private func getBuildNumber() -> Int {
        guard let bundleVersionString = infoDictionary["CFBundleVersion"] as? String,
              let buildNumber = Int(bundleVersionString) else { return 0 }
        return buildNumber
    }

    private func getBuildSKU() -> String {
        let formattedBuildDateString = buildSKUDateFormatter.string(from: Date(timeIntervalSince1970: buildDateUnixDouble))

        var threeLetterID = codeName.uppercased()
        if codeName.count > 3 {
            let prefix = String(codeName.first!)
            let suffix = String(codeName.last!)
            let middleLetterIndex = codeName.index(codeName.startIndex, offsetBy: Int((Double(codeName.count) / 2).rounded(.down)))
            threeLetterID = "\(prefix)\(String(codeName[middleLetterIndex]))\(suffix)".uppercased()
        }

        return "\(formattedBuildDateString)-\(threeLetterID)-\(String(format: "%06d", getBuildNumber()))\(stage.shortString)"
    }

    private func getBundleReleaseVersion() -> String {
        guard let shortReleaseVersionString = infoDictionary["CFBundleShortReleaseVersionString"] as? String else { return .init() }
        return shortReleaseVersionString
    }

    private func getBundleVersion() -> String {
        guard !isReleaseBuild else { return getBundleReleaseVersion() }
        guard let bundleReleaseVersionString = infoDictionary["CFBundleReleaseVersion"] as? String,
              let currentReleaseBuildNumber = Int(bundleReleaseVersionString) else { return .init() }
        return "\(String(appStoreReleaseVersion)).\(String(currentReleaseBuildNumber / 150)).\(String(currentReleaseBuildNumber / 50))"
    }

    private func getExpirationOverrideCode() -> String {
        guard !codeName.isEmpty,
              let firstCharacter = codeName.first,
              let lastCharacter = codeName.last else { return "000000" }

        let firstLetter = String(firstCharacter)
        let lastLetter = String(lastCharacter)

        let middleIndex = codeName.index(
            codeName.startIndex,
            offsetBy: Int((Double(codeName.count) / 2).rounded(.down))
        )
        let middleLetter = String(codeName[middleIndex])

        return [firstLetter, middleLetter, lastLetter].reduce(into: [String]()) { partialResult, letter in
            if let position = letter.alphabeticalPosition {
                partialResult.append(.init(format: "%02d", position))
            }
        }.joined()
    }

    private func getIsReleaseBuild() -> Bool {
        guard let isReleaseBuild = infoDictionary["IsReleaseBuild"] as? Bool else { return true }
        return isReleaseBuild
    }

    private func getExpiryDate() -> Date {
        guard let futureDate = calendar.date(byAdding: .day, value: 30, to: .init(timeIntervalSince1970: buildDateUnixDouble).comparator) else { return Date() }
        return futureDate.comparator
    }

    private func getExpiryInfoString() -> String {
        let expiryDate = getExpiryDate()
        let expiryDateComponents = calendar.dateComponents(
            [.day],
            from: Date().comparator,
            to: expiryDate.comparator
        )

        guard let daysUntilExpiry = expiryDateComponents.day else { return .init() }

        var expiryInfoString = "The evaluation period for this build will expire on ⌘\(expiryInfoStringDateFormatter.string(from: expiryDate))⌘."
        expiryInfoString += " After this date, the entry of a six-digit expiration override code will be required to continue using this software."
        expiryInfoString += " It is strongly encouraged that the build be updated before the end of the evaluation period."

        guard daysUntilExpiry <= 0 else { return expiryInfoString }
        return "The evaluation period for this build ended on ⌘\(expiryInfoStringDateFormatter.string(from: expiryDate))⌘."
    }

    private func getNetworkStatus() -> Bool {
        guard let reachability = try? Reachability() else { return false }
        return reachability.connection.description != "No Connection"
    }

    private func getProjectID() -> String {
        let firstCompileDate = projectIDDateFormatter.date(from: dmyFirstCompileDateString) ?? projectIDDateFormatter.date(from: "29062007")!

        let firstLetterPosition = String(codeName.first!).alphabeticalPosition ?? 0
        let lastLetterPosition = String(codeName.last!).alphabeticalPosition ?? 0

        let dateComponents = calendar.dateComponents(
            [.day, .month, .year],
            from: firstCompileDate
        )

        let offset = Int((Double(codeName.count) / 2).rounded(.down))
        let middleLetterIndex = codeName.index(codeName.startIndex, offsetBy: offset)
        let middleLetter = String(codeName[middleLetterIndex])
        let middleLetterPosition = middleLetter.alphabeticalPosition ?? 0

        let multipliedLetterPositions = firstLetterPosition * middleLetterPosition * lastLetterPosition
        let multipliedDateComponents = dateComponents.day! * dateComponents.month! * dateComponents.year!
        let multipliedConstants = String(multipliedLetterPositions * multipliedDateComponents).map { String($0) }

        var projectIDComponents = [String]()

        for integerString in multipliedConstants {
            projectIDComponents.append(integerString)

            guard let integer = Int(integerString) else { continue }
            let cipheredMiddleLetter = middleLetter.ciphered(by: integer).uppercased()
            projectIDComponents.append(cipheredMiddleLetter)
        }

        projectIDComponents = Array(NSOrderedSet(array: projectIDComponents)) as? [String] ?? []

        if projectIDComponents.count > 8 {
            while projectIDComponents.count > 8 {
                projectIDComponents.removeLast()
            }
        } else if projectIDComponents.count < 8 {
            var currentLetter = middleLetter

            while projectIDComponents.count < 8 {
                guard let position = currentLetter.alphabeticalPosition else { continue }
                currentLetter = currentLetter.ciphered(by: position)

                guard !projectIDComponents.contains(currentLetter) else { continue }
                projectIDComponents.append(currentLetter)
            }
        }

        return (Array(NSOrderedSet(array: projectIDComponents)) as? [String] ?? []).joined()
    }

    private func getReleaseBuildNumber() -> Int {
        guard let bundleVersionString = infoDictionary["CFBundleReleaseVersion"] as? String,
              let buildNumber = Int(bundleVersionString) else { return 0 }
        return buildNumber
    }
}

/* MARK: Date Formatter Dependencies */

private enum BuildSKUDateFormatterDependency: DependencyKey {
    public static func resolve(_: DependencyValues) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyy"
        return formatter
    }
}

private enum ExpiryInfoStringDateFormatterDependency: DependencyKey {
    public static func resolve(_: DependencyValues) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
}

private enum ProjectIDDateFormatterDependency: DependencyKey {
    public static func resolve(_: DependencyValues) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyy"
        return formatter
    }
}

private extension DependencyValues {
    var buildSKUDateFormatter: DateFormatter {
        get { self[BuildSKUDateFormatterDependency.self] }
        set { self[BuildSKUDateFormatterDependency.self] = newValue }
    }

    var expiryInfoStringDateFormatter: DateFormatter {
        get { self[ExpiryInfoStringDateFormatterDependency.self] }
        set { self[ExpiryInfoStringDateFormatterDependency.self] = newValue }
    }

    var projectIDDateFormatter: DateFormatter {
        get { self[ProjectIDDateFormatterDependency.self] }
        set { self[ProjectIDDateFormatterDependency.self] = newValue }
    }
}
