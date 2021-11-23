//
//  SFLiteralOption.swift
//  SFLoggingKit
//
//  Created by Aleksandar Sergeev Petrov on 23.11.21.
//

import Foundation

public struct SFLiteralOption: OptionSet, Equatable, Hashable {

    // MARK: - Log Levels

    /// Creates a new default `.disabled` instance with a bitmask where all bits are equal to 0.
    public static let disabled: SFLiteralOption = SFLiteralOption(rawValue: 0)

    /// Creates a new default `.file` instance with a bitmask of `1`.
    public static let file: SFLiteralOption = SFLiteralOption(rawValue: 1 << 0)

    /// Creates a new default `.function` instance with a bitmask of `1 << 1`.
    public static let function: SFLiteralOption = SFLiteralOption(rawValue: 1 << 1)

    /// Creates a new default `.line` instance with a bitmask of `1 << 2`.
    public static let line: SFLiteralOption = SFLiteralOption(rawValue: 1 << 2)

    /// Creates a new default `.all` instance with a bitmask where all bits equal are equal to `1`.
    public static let all: SFLiteralOption = SFLiteralOption(rawValue: 0b11111111)

    // MARK: - RawRepresentable

    /// Defines the RawValue type as a UInt8 to satisfy the `RawRepresentable` protocol.
    public typealias RawValue = UInt8

    /// Returns the raw bitmask value of the LogLevel and satisfies the `RawRepresentable` protocol.
    public let rawValue: RawValue

    /// Creates a literals options instance with the given raw value.
    ///
    /// - Parameter rawValue: The raw bitmask value for the log level.
    ///
    /// - Returns: A new log level instance.
    public init(rawValue: RawValue) {
        self.rawValue = rawValue
    }
    
}
