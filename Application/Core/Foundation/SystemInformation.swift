//
//  SystemInformation.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

// swiftlint:disable force_try line_length
public enum SystemInformation {
    // MARK: - Types

    private enum SystemInformationError: Error {
        case invalidSize
        case malformedUtf8
        case posixError(POSIXErrorCode)
        case unknownError
    }

    // MARK: - Properties

    public static var activeCPUs: Int64 {
        return try! informationInteger(withLevels: CTL_HW, HW_AVAILCPU)
    }

    public static var deviceName: String {
        return try! informationString(withLevels: CTL_KERN, KERN_HOSTNAME)
    }

    public static var kernelVersion: String {
        return try! informationString(withLevels: CTL_KERN, KERN_VERSION)
    }

    public static var modelCode: String {
        #if os(iOS) && !arch(x86_64) && !arch(i386)
        return try! informationString(withLevels: CTL_HW, HW_MODEL)
        #else
        return try! informationString(withLevels: CTL_HW, HW_MACHINE)
        #endif
    }

    public static var modelName: String {
        #if os(iOS) && !arch(x86_64) && !arch(i386)
        return try! informationString(withLevels: CTL_HW, HW_MACHINE)
        #else
        return try! informationString(withLevels: CTL_HW, HW_MODEL)
        #endif
    }

    public static var osRelease: String {
        return try! informationString(withLevels: CTL_KERN, KERN_OSRELEASE)
    }

    public static var osRevision: Int64 {
        return try! informationInteger(withLevels: CTL_KERN, KERN_OSREV)
    }

    public static var osType: String {
        return try! informationString(withLevels: CTL_KERN, KERN_OSTYPE)
    }

    public static var osVersion: String {
        return try! informationString(withLevels: CTL_KERN, KERN_OSVERSION)
    }

    // MARK: - Auxiliary

    private static func getInformation(fromLevelName: String) throws -> [Int32] {
        var levelBufferSize = Int(CTL_MAXNAME)

        var levelBuffer = [Int32](repeating: 0, count: levelBufferSize)

        try levelBuffer.withUnsafeMutableBufferPointer { (levelBufferPointer: inout UnsafeMutableBufferPointer<Int32>) throws in
            try fromLevelName.withCString { (nameBufferPointer: UnsafePointer<Int8>) throws in
                guard sysctlnametomib(nameBufferPointer, levelBufferPointer.baseAddress, &levelBufferSize) == 0 else {
                    throw POSIXErrorCode(rawValue: errno).map { SystemInformationError.posixError($0) } ?? SystemInformationError.unknownError
                }
            }
        }

        if levelBuffer.count > levelBufferSize {
            levelBuffer.removeSubrange(levelBufferSize ..< levelBuffer.count)
        }

        return levelBuffer
    }

    private static func getInformation(withLevels: [Int32]) throws -> [Int8] {
        return try withLevels.withUnsafeBufferPointer { levelsPointer throws -> [Int8] in
            var requiredSize = 0

            let preFlightResult = Darwin.sysctl(UnsafeMutablePointer<Int32>(mutating: levelsPointer.baseAddress), UInt32(withLevels.count), nil, &requiredSize, nil, 0)

            if preFlightResult != 0 {
                throw POSIXErrorCode(rawValue: errno).map { SystemInformationError.posixError($0) } ?? SystemInformationError.unknownError
            }

            let arrayBufferData = [Int8](repeating: 0, count: requiredSize)

            let representedResult = arrayBufferData.withUnsafeBufferPointer { dataBuffer -> Int32 in
                Darwin.sysctl(UnsafeMutablePointer<Int32>(mutating: levelsPointer.baseAddress), UInt32(withLevels.count), UnsafeMutableRawPointer(mutating: dataBuffer.baseAddress), &requiredSize, nil, 0)
            }

            if representedResult != 0 {
                throw POSIXErrorCode(rawValue: errno).map { SystemInformationError.posixError($0) } ?? SystemInformationError.unknownError
            }

            return arrayBufferData
        }
    }

    private static func informationInteger(withLevels: Int32...) throws -> Int64 {
        return try integerFromSystemInformation(withLevels: withLevels)
    }

    private static func informationInteger(withName: String) throws -> Int64 {
        return try integerFromSystemInformation(withLevels: getInformation(fromLevelName: withName))
    }

    private static func informationString(withLevels: Int32...) throws -> String {
        return try stringFromSystemInformation(withLevels: withLevels)
    }

    private static func informationString(withName: String) throws -> String {
        return try stringFromSystemInformation(withLevels: getInformation(fromLevelName: withName))
    }

    private static func integerFromSystemInformation(withLevels: [Int32]) throws -> Int64 {
        let informationBuffer = try getInformation(withLevels: withLevels)

        switch informationBuffer.count {
        case 4: return informationBuffer.withUnsafeBufferPointer { $0.baseAddress.map { $0.withMemoryRebound(to: Int32.self, capacity: 1) { Int64($0.pointee) }} ?? 0 }

        case 8: return informationBuffer.withUnsafeBufferPointer { $0.baseAddress.map { $0.withMemoryRebound(to: Int64.self, capacity: 1) { $0.pointee }} ?? 0 }

        default: throw SystemInformationError.invalidSize
        }
    }

    private static func stringFromSystemInformation(withLevels: [Int32]) throws -> String {
        let optionalString = try getInformation(withLevels: withLevels).withUnsafeBufferPointer { dataPointer -> String? in
            dataPointer.baseAddress.flatMap { String(validatingUTF8: $0) }
        }

        guard let returnedString = optionalString else {
            throw SystemInformationError.malformedUtf8
        }

        return returnedString
    }
}

// swiftlint:enable force_try line_length
