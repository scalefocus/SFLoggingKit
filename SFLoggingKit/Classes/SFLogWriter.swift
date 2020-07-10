//
//  SFLogWriter.swift
//  SFLoggingKit
//
//  Created by Aleksandar Sergeev Petrov on 7.07.20.
//

import Foundation
import os.log

/// The `SFLogWriter` protocol defines a single API for writing a log message. The message can be written in any way
/// the conforming object sees fit. For example, it could write to the console, write to a file, remote log to a third
/// party service, etc.
public protocol SFLogWriter {
    func log(_ message: String, logLevel: SFLogLevel)
}

public protocol SFLogModifier {
    
}

// MARK: - Console

/// The ConsoleWriter class runs all modifiers in the order they were created and prints the resulting message
/// to the console.
open class SFConsoleWriter: SFLogWriter {

    // NOTE: Consider adding color

    // MARK: - Properties

    /// Determines if the logs should be visible when attatching a device and debugging in the console
    private let shouldLogInBackgroundConsole: Bool

    // MARK: - Initializers

    /// Initializes a console writer instance.
    ///
    /// - Parameter shouldLogInBackgroundConsole: The function to use when logging to the console. Defaults to `print`.
    ///
    /// - Returns: A new console writer instance.
    public init(shouldLogInBackgroundConsole: Bool = false) {
        self.shouldLogInBackgroundConsole = shouldLogInBackgroundConsole
    }

    // MARK: - SFLogWriter

    /// Writes the message to the console using the global `print` or `NSLog`  function.
    ///
    /// Modifier is run over the message in the order to provide log level before writing the message to
    /// the console.
    ///
    /// - Parameters:
    ///   - message: The original message to write to the console.
    ///   - logLevel: The log level associated with the message.
    ///
    /// - Returns: A new `SFConsoleWriter` instance.
    open func log(_ message: String, logLevel: SFLogLevel) {
        if shouldLogInBackgroundConsole {
            NSLog(message)
        } else {
            print(message)
        }
    }

}

// MARK: - OSLog

/// The OSLogWriter class runs all modifiers in the order they were created and passes the resulting message
/// off to an OSLog with the specified subsystem and category.
open class SFOSLogWriter: SFLogWriter {

    // MARK: - Properties

    public let subsystem: String
    public let category: String

    // MARK: - Initializers

    /// Creates an `OSLogWriter` instance from the specified `subsystem` and `category`.
    ///
    /// - Parameters:
    ///   - subsystem: The subsystem. Default is app bundle identifier
    ///   - category: The category. E.g. `ui`, `firebase`, `networking`, etc.
    ///
    /// - Returns: A new `SFOSLogWriter` instance.
    public init(subsystem: String = Bundle.main.bundleIdentifier!, category: String) {
        self.subsystem = subsystem
        self.category = category
        self.log = OSLog(subsystem: subsystem, category: category)
    }

    // MARK: - SFLogWriter

    /// Writes the message to the `OSLog` using the `os_log` function.
    ///
    /// - Parameters:
    ///   - message: The original message to write to the console.
    ///   - logLevel: The log level associated with the message.
    open func log(_ message: String, logLevel: SFLogLevel) {
        // get mathcing os_log log type
        let type = logType(forLogLevel: logLevel)
        os_log("%@", log: log, type: type, message)
    }

    // MARK: - OSLog

    private let log: OSLog

    /// Returns the `OSLogType` to use for the specified `SFLogLevel`.
    ///
    /// - Parameter logLevel: The level to be map to a `OSLogType`.
    ///
    /// - Returns: An `OSLogType` corresponding to the `SFLogLevel`.
    open func logType(forLogLevel logLevel: SFLogLevel) -> OSLogType {
        switch logLevel {
        case SFLogLevel.debug:      return .debug
        case SFLogLevel.info:       return .info
        case SFLogLevel.warning:    return .default
        case SFLogLevel.error:      return .error
        case SFLogLevel.severe:     return .fault
        default:                    return .default
        }
    }

}

// MARK: - File
