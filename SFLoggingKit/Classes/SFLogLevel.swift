//
//  SFLogLevel.swift
//  Pods-LoggingKit_Tests
//
//  Created by Aleksandar Sergeev Petrov on 7.07.20.
//

import Foundation

/// The different Loglevels
///
/// Debug: Should be used for debug purposes.
/// Info: Should be used to log valuable information (possibly for testing on live).
/// Warning: Should log various warnings or not very significant errors. Use this level to capture information about things that might result in a failure.
/// Error: Should log errors (Server errors, library failures and so on)
/// Severe: Should log severe errors, crashes possibly or catching serious exceptions
public struct SFLogLevel: OptionSet, Equatable, Hashable {

    // MARK: - Log Levels

    /// Creates a new default `.disabled` instance with a bitmask where all bits are equal to 0.
    public static let disabled: SFLogLevel = SFLogLevel(rawValue: 0)

    /// Creates a new default `.debug` instance with a bitmask of `1`.
    public static let debug: SFLogLevel = SFLogLevel(rawValue: 1 << 0)

    /// Creates a new default `.info` instance with a bitmask of `1 << 1`.
    public static let info: SFLogLevel = SFLogLevel(rawValue: 1 << 1)

    /// Creates a new default `.warning` instance with a bitmask of `1 << 2`.
    public static let warning: SFLogLevel = SFLogLevel(rawValue: 1 << 2)

    /// Creates a new default `.error` instance with a bitmask of `1 << 3`.
    public static let error: SFLogLevel = SFLogLevel(rawValue: 1 << 3)

    /// Creates a new default `.severe` instance with a bitmask of `1 << 4`.
    public static let severe: SFLogLevel = SFLogLevel(rawValue: 1 << 4)

    // NOTE: The empty bits that remain allow custom log levels to
    // be inter-mixed with the default log levels very easily.

    /// Creates a new default `.all` instance with a bitmask where all bits equal are equal to `1`.
    public static let all = SFLogLevel(rawValue: 0b11111111)

    // MARK: - RawRepresentable

    /// Defines the RawValue type as a UInt8 to satisfy the `RawRepresentable` protocol.
    public typealias RawValue = UInt8

    /// Returns the raw bitmask value of the LogLevel and satisfies the `RawRepresentable` protocol.
    public let rawValue: RawValue

    /// Creates a log level instance with the given raw value.
    ///
    /// - Parameter rawValue: The raw bitmask value for the log level.
    ///
    /// - Returns: A new log level instance.
    public init(rawValue: RawValue) {
        self.rawValue = rawValue
    }

}

// MARK: - CustomStringConvertible

extension SFLogLevel: CustomStringConvertible {
    /// Returns a `String` representation of the `SFLogLevel`.
    public var description: String {
        switch self {
        case SFLogLevel.debug:
            return "Debug"
        case SFLogLevel.info:
            return "Info"
        case SFLogLevel.warning:
            return "Warning"
        case SFLogLevel.error:
            return "Error"
        case SFLogLevel.severe:
            return "Severe"
        case .disabled:
            return "Disabled"
        case .all:
            return "All"
        default:
            return "Unknown"
        }
    }
}
