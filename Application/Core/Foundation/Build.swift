//
//  Build.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import Redux

public class Build {
    // MARK: - Types

    public enum Stage: String {
        case preAlpha /* Typically builds 0-1500. */
        case alpha /* Typically builds 1500-3000. */
        case beta /* Typically builds 3000-6000. */
        case releaseCandidate /* Typically builds 6000 onwards. */
        case generalRelease

        public func description(short: Bool) -> String {
            switch self {
            case .preAlpha:
                return short ? "p" : "pre-alpha"
            case .alpha:
                return short ? "a" : "alpha"
            case .beta:
                return short ? "b" : "beta"
            case .releaseCandidate:
                return short ? "c" : "release candidate"
            default:
                return short ? "g" : "general"
            }
        }
    }

    // MARK: - Dependencies

    @Dependency(\.currentCalendar) private var calendar: Calendar

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

    // String
    public var buildSKU: String { getBuildSKU() }
    public var bundleVersion: String { getBundleVersion() }
    public var expiryInfoString: String { getExpiryInfoString() }
    public var projectID: String { getProjectID() }

    // Other
    public var buildNumber: Int { getBuildNumber() }
    public var expiryDate: Date { getExpiryDate() }
    public var isOnline: Bool { getNetworkStatus() }

    private var buildDateUnixDouble: TimeInterval {
        guard let cfBuildDate = infoDictionary["CFBuildDate"] as? String else { return .init() }
        guard cfBuildDate != "1183100400" else {
            return .init(String(Date().timeIntervalSince1970).components(separatedBy: ".")[0]) ?? .init()
        }

        return .init(cfBuildDate) ?? .init()
    }

    private var infoDictionary: [String: Any] { Bundle.main.infoDictionary ?? [:] }

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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMyy"

        let formattedBuildDateString = dateFormatter.string(from: Date(timeIntervalSince1970: buildDateUnixDouble))

        var threeLetterID = codeName.uppercased()
        if codeName.count > 3 {
            let prefix = String(codeName.first!)
            let suffix = String(codeName.last!)
            let middleLetterIndex = codeName.index(codeName.startIndex, offsetBy: Int((Double(codeName.count) / 2).rounded(.down)))
            threeLetterID = "\(prefix)\(String(codeName[middleLetterIndex]))\(suffix)".uppercased()
        }

        return "\(formattedBuildDateString)-\(threeLetterID)-\(String(format: "%06d", getBuildNumber()))\(stage.description(short: true))"
    }

    private func getBundleVersion() -> String {
        guard let bundleReleaseVersionString = infoDictionary["CFBundleReleaseVersion"] as? String,
              let currentReleaseBuildNumber = Int(bundleReleaseVersionString) else { return .init() }
        return "\(String(appStoreReleaseVersion)).\(String(currentReleaseBuildNumber / 150)).\(String(currentReleaseBuildNumber / 50))"
    }

    private func getExpiryDate() -> Date {
        guard let futureDate = calendar.date(byAdding: .day, value: 30, to: .init(timeIntervalSince1970: buildDateUnixDouble).comparator) else { return Date() }
        return futureDate.comparator
    }

    private func getExpiryInfoString() -> String {
        let expiryDate = getExpiryDate()

        let expiryDateFormatter = DateFormatter()
        expiryDateFormatter.dateFormat = "yyyy-MM-dd"

        let expiryDateComponents = calendar.dateComponents(
            [.day],
            from: Date().comparator,
            to: expiryDate.comparator
        )

        guard let daysUntilExpiry = expiryDateComponents.day else { return .init() }

        var expiryInfoString = "The evaluation period for this build will expire on \(expiryDateFormatter.string(from: expiryDate))."
        expiryInfoString += " After this date, the entry of a six-digit expiration override code will be required to continue using this software."
        expiryInfoString += " It is strongly encouraged that the build be updated before the end of the evaluation period."

        if daysUntilExpiry <= 0 {
            expiryInfoString = "The evaluation period for this build ended on \(expiryDateFormatter.string(from: expiryDate))."
        }

        return expiryInfoString
    }

    private func getNetworkStatus() -> Bool {
        guard let reachability = try? Reachability() else { return false }
        return reachability.connection.description != "No Connection"
    }

    private func getProjectID() -> String {
        let identifierDateFormatter = DateFormatter()
        identifierDateFormatter.dateFormat = "ddMMyyyy"

        let firstCompileDate = identifierDateFormatter.date(from: dmyFirstCompileDateString) ?? identifierDateFormatter.date(from: "29062007")!

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

            let cipheredMiddleLetter = middleLetter.ciphered(by: Int(integerString)!).uppercased()
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

                if !projectIDComponents.contains(currentLetter) {
                    projectIDComponents.append(currentLetter)
                }
            }
        }

        return (Array(NSOrderedSet(array: projectIDComponents)) as? [String] ?? []).joined()
    }
}
