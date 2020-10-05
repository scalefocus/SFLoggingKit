//
//  SFLogMessageModifier.swift
//  Pods-LoggingKit_Tests
//
//  Created by Aleksandar Sergeev Petrov on 9.07.20.
//

import Foundation

/// The SFMessageModifier protocol defines a single method for modifying a log message after it has been constructed.
/// This is very flexible allowing any object that conforms to modify messages in any way it wants.
public protocol SFLogMessageModifier {
    func modify(_ message: String, with logLevel: SFLogLevel, _ file: String, _ function: String, _ line: Int) -> String
}

// MARK: - Timestamp

open class SFTimestampLogMessageModifier: SFLogMessageModifier {

    // MARK: - Properties
    
    public let timestampFormatter: DateFormatter

    // MARK: - Initializers

    /// Initializes a `TimestampModifier` instance.
    ///
    /// - Parameter timestampFormatter: The formatter used when the date is converted to string
    ///
    /// - Returns: A new `SFTimestampLogMessageModifier` instance.
    public init(timestampFormatter: DateFormatter = .logTimestampFormatter) {
        self.timestampFormatter = timestampFormatter
    }

    // MARK: - SFLogMessageModifier

    /// Applies a timestamp to the beginning of the message.
    ///
    /// - Parameters:
    ///   - message:  The original message to format.
    ///   - logLevel: The log level set for the message.
    ///   - file: The file in which the call happens.
    ///   - function: The function in which the call happens.
    ///   - line: The line at which the call happens.
    ///
    /// - Returns: A newly formatted message.
    open func modify(_ message: String, with logLevel: SFLogLevel, _ file: String, _ function: String, _ line: Int) -> String {
        let timestampString = timestampFormatter.string(from: Date())
        return "\(timestampString) \(message)"
    }

}

// MARK: - Symbol

open class SFSymbolLogMessageModifier: SFLogMessageModifier {

    // MARK: - SFLogMessageModifier

    /// Applies a timestamp to the beginning of the message.
    ///
    /// - Parameters:
    ///   - message:  The original message to format.
    ///   - logLevel: The log level set for the message.
    ///   - file: The file in which the call happens.
    ///   - function: The function in which the call happens.
    ///   - line: The line at which the call happens.
    ///
    /// - Returns: A newly formatted message.
    open func modify(_ message: String, with logLevel: SFLogLevel, _ file: String, _ function: String, _ line: Int) -> String {
        return "\(logLevel.symbol) \(message)"
    }

}

// MARK: - Log Level Name

open class SFLevelNameLogMessageModifier: SFLogMessageModifier {

    // MARK: - SFMessageModifier

    /// Applies a timestamp to the beginning of the message.
    ///
    /// - Parameters:
    ///   - message:  The original message to format.
    ///   - logLevel: The log level set for the message.
    ///   - file: The file in which the call happens.
    ///   - function: The function in which the call happens.
    ///   - line: The line at which the call happens.
    ///
    /// - Returns: A newly formatted message.
    open func modify(_ message: String, with logLevel: SFLogLevel, _ file: String, _ function: String, _ line: Int) -> String {
        return "[\(logLevel.description)] \(message)"
    }

}

// MARK: - Literals

public struct LiteralOption: OptionSet, Equatable, Hashable {

    // MARK: - Log Levels

    /// Creates a new default `.disabled` instance with a bitmask where all bits are equal to 0.
    public static let disabled: LiteralOption = LiteralOption(rawValue: 0)

    /// Creates a new default `.file` instance with a bitmask of `1`.
    public static let file: LiteralOption = LiteralOption(rawValue: 1 << 0)

    /// Creates a new default `.function` instance with a bitmask of `1 << 1`.
    public static let function: LiteralOption = LiteralOption(rawValue: 1 << 1)

    /// Creates a new default `.line` instance with a bitmask of `1 << 2`.
    public static let line: LiteralOption = LiteralOption(rawValue: 1 << 2)

    /// Creates a new default `.all` instance with a bitmask where all bits equal are equal to `1`.
    public static let all: LiteralOption = LiteralOption(rawValue: 0b11111111)

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

//

open class SFLiteralLogMessageModifier: SFLogMessageModifier {

    // MARK: - Properties

    public let options: LiteralOption

    // NOTE: Add option to choose wheather to keep file extension or not.
    // NOTE: Add option to change format

    // MARK: - Initializers

    /// Creates an `LiteralExpressionModifier` instance with the specified `options`
    ///
    /// - Parameter options: The literals that should be added to the message
    ///
    /// - Returns: A new `SFLiteralLogMessageModifier` instance.
    public init(options: LiteralOption = .all) {
        self.options = options
    }

    // MARK: - SFMessageModifier

    /// Applies a timestamp to the beginning of the message.
    ///
    /// - Parameters:
    ///   - message:  The original message to format.
    ///   - logLevel: The log level set for the message.
    ///   - file: The file in which the call happens.
    ///   - function: The function in which the call happens.
    ///   - line: The line at which the call happens.
    ///
    /// - Returns: A newly formatted message.
    open func modify(_ message: String, with logLevel: SFLogLevel, _ file: String, _ function: String, _ line: Int) -> String {
        var format = "{{ file }}, {{ function }} {{ line }}"
        let characterSet = CharacterSet(charactersIn: " ,")

        format = format.replacingOccurrences(of: "{{ file }}", with: sourceFileName(file))
        format = format.replacingOccurrences(of: "{{ function }}", with: sourceFileFunction(function))
        format = format.replacingOccurrences(of: "{{ line }}", with: sourceFileLine(line))

        format = format.trimmingCharacters(in: characterSet)
        if format.count > 0 {
            format = "[\(format)]"
        }

        return "\(format) \(message)"
    }

    private func sourceFileName(_ file: String) -> String {
        guard options.contains(.file) else {
            return ""
        }

        return "\(file.lastPathComponent)"
    }

    private func sourceFileFunction(_ function: String) -> String {
        guard options.contains(.function) else {
            return ""
        }

        return "\(function)"
    }

    private func sourceFileLine(_ line: Int) -> String {
        guard options.contains(.line) else {
            return ""
        }

        return "at \(line)"
    }
}

// MARK: - Sugar

/// Default log timestamp formatter sugar extension
public extension Formatter {
    static var logTimestampFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return formatter
    }()
}

/// String syntax sugar extension
extension String {
    var ns: NSString {
        return self as NSString
    }

    var lastPathComponent: String {
        return ns.lastPathComponent
    }

    var stringByDeletingPathExtension: String {
        return ns.deletingPathExtension
    }
}
