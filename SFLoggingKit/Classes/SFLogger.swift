//
//  SFLogger.swift
//  SFLoggingKit
//
//  Created by Martin Vasilev on 4.08.18.
//  Copyright © 2018 Upnetix. All rights reserved.
//

import Foundation

// MARK: - Interface

open class SFLogger {
    /// Controls whether to allow log messages to be sent to the writers.
    open var isEnabled: Bool = true

    /// Log levels this logger is configured for.
    public let logLevelsValidator: SFLogLevelsValidator

    /// The array of writers to use when messages are written.
    public let writers: [SFLogWriter]

    /// The queue used for logging.
    private let queue = DispatchQueue(label: "com.scalefocus.log")
    
    // MARK: - Initialization

    /// Initializes a logger instance.
    ///
    /// - Parameters:
    ///   - logLevelsValidator: The message levels that should be logged to the writers. Default is validate if level is equal or higher than `.debug`
    ///   - writers: Array of writers that messages should be sent to. Default is `ConsoleWriter`
    public init(logLevelsValidator: SFLogLevelsValidator = SFMinimumLogLevelValidator(),
                writers: [SFLogWriter] = [ConsoleWriter()]) {
        self.logLevelsValidator = logLevelsValidator
        self.writers = writers
    }

}

// MARK: - Log Messages

extension SFLogger {
    /// Writes out the given message using the logger if the debug log level is set.
    ///
    /// - Parameter message: An autoclosure returning the message to log.
    open func debug(_ message: @autoclosure @escaping () -> String) {
        log(message, with: SFLogLevel.debug)
    }

    /// Writes out the given message using the logger if the debug log level is set.
    ///
    /// - Parameter message: A closure returning the message to log.
    open func debug(_ message: @escaping () -> String) {
        log(message, with: SFLogLevel.debug)
    }

    /// Writes out the given message using the logger if the info log level is set.
    ///
    /// - Parameter message: An autoclosure returning the message to log.
    open func info(_ message: @autoclosure @escaping () -> String) {
        log(message, with: SFLogLevel.info)
    }

    /// Writes out the given message using the logger if the info log level is set.
    ///
    /// - Parameter message: A closure  returning the message to log.
    open func info(_ message: @escaping () -> String) {
        log(message, with: SFLogLevel.info)
    }

    /// Writes out the given message using the logger if the warning log level is set.
    ///
    /// - Parameter message: An autoclosure returning the message to log.
    open func event(_ message: @autoclosure @escaping () -> String) {
        log(message, with: SFLogLevel.warning)
    }

    /// Writes out the given message using the logger if the warning log level is set.
    ///
    /// - Parameter message: A closure returning the message to log.
    open func event(_ message: @escaping () -> String) {
        log(message, with: SFLogLevel.warning)
    }

    /// Writes out the given message using the logger if the error log level is set.
    ///
    /// - Parameter message: An autoclosure returning the message to log.
    open func error(_ message: @autoclosure @escaping () -> String) {
        log(message, with: SFLogLevel.error)
    }

    /// Writes out the given message using the logger if the error log level is set.
    ///
    /// - Parameter message: A closure returning the message to log.
    open func error(_ message: @escaping () -> String) {
        log(message, with: SFLogLevel.error)
    }

    /// Writes out the given message using the logger if the severe log level is set.
    ///
    /// - Parameter message: An autoclosure returning the message to log.
    open func severe(_ message: @autoclosure @escaping () -> String) {
        log(message, with: SFLogLevel.severe)
    }

    /// Writes out the given message using the logger if the severe log level is set.
    ///
    /// - Parameter message: A closure returning the message to log.
    open func severe(_ message: @escaping () -> String) {
        log(message, with: SFLogLevel.severe)
    }

    /// Writes out the given message closure string with the logger if the log level is allowed.
    ///
    /// - Parameters:
    ///   - message: A closure returning the message to log.
    ///   - withLogLevel: The log level associated with the message closure.
    open func log(_ message: @escaping () -> String, with logLevel: SFLogLevel) {
        guard isEnabled && isLogLevelAllowed(logLevel) else {
            return
        }

        // NOTE: runs in own serial background thread for better performance
        queue.async {
            self.log(message(), with: logLevel)
        }
    }

    private func log(_ message: String, with logLevel: SFLogLevel) {
        writers.forEach { $0.log(message, logLevel: logLevel) }
    }

    private func isLogLevelAllowed(_ logLevel: SFLogLevel) -> Bool {
        return logLevelsValidator.isLogLevelAllowed(logLevel)
    }

}
