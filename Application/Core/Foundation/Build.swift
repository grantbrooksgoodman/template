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

public enum Build {
    
    // MARK: - Properties
    
    // Booleans
    public static var isOnline: Bool { getNetworkStatus() }
    
    private(set) static var developerModeEnabled = Bool()
    private(set) static var loggingEnabled = Bool()
    private(set) static var timebombActive = Bool()
    
    // Integers
    public static var buildNumber: Int { getBuildNumber() }
    
    private(set) static var appStoreReleaseVersion = Int()
    
    // Strings
    public static var buildSKU: String { getBuildSKU() }
    public static var bundleVersion: String { getBundleVersion() }
    public static var expiryInfoString: String { getExpiryInfoString() }
    public static var projectID: String { getProjectID() }
    
    private(set) static var codeName = String()
    private(set) static var finalName = String()
    
    private static var dmyFirstCompileDateString = String()
    
    // Other
    public static var expiryDate: Date { getExpiryDate() }
    
    private(set) static var stage: Stage!
    
    private static var buildDateUnixDouble: TimeInterval {
        get {
            guard let cfBuildDate = infoDictionary["CFBuildDate"] as? String else { return .init() }
            guard cfBuildDate != "1183100400" else {
                return .init(String(Date().timeIntervalSince1970).components(separatedBy: ".")[0]) ?? .init()
            }
            
            return .init(cfBuildDate) ?? .init()
        }
    }
    private static var infoDictionary: [String: Any] { Bundle.main.infoDictionary ?? [:] }
    
    // MARK: - Enums
    
    public enum Metadatum {
        case appStoreReleaseVersion
        case codeName
        case developerModeEnabled
        case dmyFirstCompileDateString
        case finalName
        case loggingEnabled
        case stage
        case timebombActive
    }
    
    public enum Stage: String {
        case preAlpha         /* Typically builds 0-1500 */
        case alpha            /* Typically builds 1500-3000 */
        case beta             /* Typically builds 3000-6000 */
        case releaseCandidate /* Typically builds 6000 onwards */
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
    
    // MARK: - Setters
    
    public static func set(_ metadata: [Metadatum: Any]) {
        for key in Array(metadata.keys) {
            set(key, to: metadata[key]!)
        }
    }
    
    public static func set(_ metadata: Metadatum, to: Any) {
        switch metadata {
        case .appStoreReleaseVersion:
            guard let value = to as? Int else { fatalError("Wrong type passed") }
            appStoreReleaseVersion = value
        case .codeName:
            guard let value = to as? String else { fatalError("Wrong type passed") }
            codeName = value
        case .developerModeEnabled:
            guard let value = to as? Bool else { fatalError("Wrong type passed") }
            developerModeEnabled = value
        case .dmyFirstCompileDateString:
            guard let value = to as? String else { fatalError("Wrong type passed") }
            dmyFirstCompileDateString = value
        case .finalName:
            guard let value = to as? String else { fatalError("Wrong type passed") }
            finalName = value
        case .loggingEnabled:
            guard let value = to as? Bool else { fatalError("Wrong type passed") }
            loggingEnabled = value
        case .stage:
            guard let value = to as? Stage else { fatalError("Wrong type passed") }
            stage = value
        case .timebombActive:
            guard let value = to as? Bool else { fatalError("Wrong type passed") }
            timebombActive = value
        }
    }
    
    // MARK: - Computed Property Getters
    
    private static func getBuildNumber() -> Int {
        guard let bundleVersionString = infoDictionary["CFBundleVersion"] as? String,
              let buildNumber = Int(bundleVersionString) else { return 0 }
        return buildNumber
    }
    
    private static func getBundleVersion() -> String {
        guard let bundleReleaseVersionString = infoDictionary["CFBundleReleaseVersion"] as? String,
              let currentReleaseBuildNumber = Int(bundleReleaseVersionString) else { return .init() }
        return "\(String(appStoreReleaseVersion)).\(String(currentReleaseBuildNumber / 150)).\(String(currentReleaseBuildNumber / 50))"
    }
    
    private static func getBuildSKU() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMyy"
        
        let formattedBuildDateString = dateFormatter.string(from: Date(timeIntervalSince1970: buildDateUnixDouble))
        
        let threeLetterCodeNameIdentifier = (Build.codeName.count > 3 ? "\(String(Build.codeName.first!))\(String(Build.codeName[Build.codeName.index(Build.codeName.startIndex, offsetBy: Int((Double(Build.codeName.count) / 2).rounded(.down)))]))\(String(Build.codeName.last!))".uppercased() : Build.codeName.uppercased())
        
        return "\(formattedBuildDateString)-\(threeLetterCodeNameIdentifier)-\(String(format: "%06d", getBuildNumber()))\(Build.stage.description(short: true))"
    }
    
    private static func getExpiryDate() -> Date {
        @Dependency(\.currentCalendar) var calendar: Calendar
        guard let futureDate = calendar.date(byAdding: .day, value: 30, to: .init(timeIntervalSince1970: buildDateUnixDouble).comparator) else { return .init() }
        return futureDate.comparator
    }
    
    private static func getExpiryInfoString() -> String {
        @Dependency(\.currentCalendar) var calendar: Calendar
        
        let expiryDate = getExpiryDate()
        
        let expiryDateFormatter = DateFormatter()
        expiryDateFormatter.dateFormat = "yyyy-MM-dd"
        
        let expiryDateComponents = calendar.dateComponents([.day],
                                                           from: Date().comparator,
                                                           to: expiryDate.comparator)
        
        guard let daysUntilExpiry = expiryDateComponents.day else { return .init() }
        
        var expiryInfoString = "The evaluation period for this build will expire on \(expiryDateFormatter.string(from: expiryDate)). After this date, the entry of a six-digit expiration override code will be required to continue using this software. It is strongly encouraged that the build be updated before the end of the evaluation period."
        
        expiryInfoString = daysUntilExpiry <= 0 ? "The evaluation period for this build ended on \(expiryDateFormatter.string(from: expiryDate))." : expiryInfoString
        
        return expiryInfoString
    }
    
    private static func getNetworkStatus() -> Bool {
        guard let reachability = try? Reachability() else { return false }
        return reachability.connection.description != "No Connection"
    }
    
    private static func getProjectID() -> String {
        @Dependency(\.currentCalendar) var calendar: Calendar
        
        let identifierDateFormatter = DateFormatter()
        identifierDateFormatter.dateFormat = "ddMMyyyy"
        
        let firstCompileDate = identifierDateFormatter.date(from: dmyFirstCompileDateString) ?? identifierDateFormatter.date(from: "29062007")!
        
        let firstLetterPosition = String(Build.codeName.first!).alphabeticalPosition ?? 0
        let lastLetterPosition = String(Build.codeName.last!).alphabeticalPosition ?? 0
        
        let dateComponents = calendar.dateComponents([.day, .month, .year],
                                                     from: firstCompileDate)
        
        let offset = Int((Double(Build.codeName.count) / 2).rounded(.down))
        let middleLetterIndex = Build.codeName.index(Build.codeName.startIndex, offsetBy: offset)
        let middleLetter = String(Build.codeName[middleLetterIndex])
        let middleLetterPosition = middleLetter.alphabeticalPosition ?? 0
        
        let multipliedConstants = String(firstLetterPosition * middleLetterPosition * lastLetterPosition * dateComponents.day! * dateComponents.month! * dateComponents.year!).map({ String($0) })
        
        var projectIdComponents = [String]()
        
        for integerString in multipliedConstants {
            projectIdComponents.append(integerString)
            
            let cipheredMiddleLetter = middleLetter.ciphered(by: Int(integerString)!).uppercased()
            projectIdComponents.append(cipheredMiddleLetter)
        }
        
        projectIdComponents = Array(NSOrderedSet(array: projectIdComponents)) as! [String]
        
        if projectIdComponents.count > 8 {
            while projectIdComponents.count > 8 {
                projectIdComponents.removeLast()
            }
        } else if projectIdComponents.count < 8 {
            var currentLetter = middleLetter
            
            while projectIdComponents.count < 8 {
                guard let position = currentLetter.alphabeticalPosition else { continue }
                currentLetter = currentLetter.ciphered(by: position)
                
                if !projectIdComponents.contains(currentLetter) {
                    projectIdComponents.append(currentLetter)
                }
            }
        }
        
        return (Array(NSOrderedSet(array: projectIdComponents)) as! [String]).joined()
    }
}
