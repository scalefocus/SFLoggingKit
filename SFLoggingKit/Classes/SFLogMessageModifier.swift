//
//  SFLogMessageModifier.swift
//  Pods-LoggingKit_Tests
//
//  Created by Aleksandar Sergeev Petrov on 9.07.20.
//

import Foundation

/// The `SFMessageModifier` protocol defines a single method for modifying a log message after it has been constructed.
///
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
    open func modify(_ message: String,
                     with logLevel: SFLogLevel,
                     _ file: String,
                     _ function: String,
                     _ line: Int) -> String {
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
    open func modify(_ message: String,
                     with logLevel: SFLogLevel,
                     _ file: String,
                     _ function: String,
                     _ line: Int) -> String {
        "\(logLevel.symbol) \(message)"
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
    open func modify(_ message: String,
                     with logLevel: SFLogLevel,
                     _ file: String,
                     _ function: String,
                     _ line: Int) -> String {
        "[\(logLevel.description)] \(message)"
    }

}

// MARK: - Literals

open class SFLiteralLogMessageModifier: SFLogMessageModifier {

    // MARK: - Properties

    public let options: SFLiteralOption

    // MARK: - Initializers

    /// Creates an `LiteralExpressionModifier` instance with the specified `options`
    ///
    /// - Parameter options: The literals that should be added to the message
    ///
    /// - Returns: A new `SFLiteralLogMessageModifier` instance.
    public init(options: SFLiteralOption = .all) {
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
    open func modify(_ message: String,
                     with logLevel: SFLogLevel,
                     _ file: String,
                     _ function: String,
                     _ line: Int) -> String {
        var format = "{{ file }}, {{ function }} {{ line }}"
        let characterSet = CharacterSet(charactersIn: " ,")

        format = format.replacingOccurrences(of: "{{ file }}", with: sourceFileName(file))
        format = format.replacingOccurrences(of: "{{ function }}", with: sourceFileFunction(function))
        format = format.replacingOccurrences(of: "{{ line }}", with: sourceFileLine(line))

        format = format.trimmingCharacters(in: characterSet)
        if !format.isEmpty {
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
