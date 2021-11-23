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

    // MARK: - Instances

    /// Default instance. Writes to console using `print()`. Adds Timestamp, file name, calling function, line and log level name
    public static let `default`: SFLogger = {
        SFLogger(
            minLevel: .debug,
            writers: [SFConsoleLogWriter()],
            modifiers: [
                // NOTE: Will be printed in reverse order
                SFLevelNameLogMessageModifier(),
                SFLiteralLogMessageModifier(),
                SFTimestampLogMessageModifier()
            ]
        )
    }()

    // MARK: - Properties

    /// Controls whether to allow log messages to be sent to the writers.
    open var isEnabled: Bool = true

    /// Should write log messages asynchronously. Default is `true`.
    open var isAsynchronous: Bool = true

    /// The array of writers to use when messages are written.
    public let writers: [SFLogWriter]

    public let modifiers: [SFLogMessageModifier]

    /// The queue used for logging.
    private let queue = DispatchQueue(label: "com.scalefocus.log")

    /// Log levels this logger is configured for.
    private let logLevelsValidator: SFLogLevelsValidator

    // MARK: - Initialization

    /// Initializes a logger instance.
    ///
    /// - Parameters:
    ///   - logLevelsValidator: The message levels that should be logged to the writers.
    ///   - writers: Array of writers that messages should be sent to.
    ///   - modifiers: Array of modifiers that the writer should execute (in order) on incoming messages.
    ///
    /// - Returns: A new `SFLogger` instance.
    public init(logLevelsValidator: SFLogLevelsValidator,
                writers: [SFLogWriter],
                modifiers: [SFLogMessageModifier] = []) {
        self.logLevelsValidator = logLevelsValidator
        self.writers = writers
        self.modifiers = modifiers
    }

    /// Initializes a logger instance.
    ///
    /// - Parameters:
    ///   - minLevel:   The minimum levels fro message that should be logged to the writers. Default is validate if level is equal or higher than `.debug`
    ///   - writers:    Array of writers that messages should be sent to.
    ///   - modifiers:  Array of modifiers that the writer should execute (in order) on incoming messages.
    ///
    /// - Returns: A new `SFLogger` instance.
    public convenience init(minLevel: SFLogLevel = .debug,
                            writers: [SFLogWriter],
                            modifiers: [SFLogMessageModifier] = []) {
        self.init(logLevelsValidator: SFMinimumLogLevelValidator(minLevel: minLevel),
                  writers: writers,
                  modifiers: modifiers)
    }

    /// Initializes a logger instance.
    ///
    /// - Parameters:
    ///   - logLevels: The message levels that should be logged to the writers. Default is validate if level is equal or higher than `.all`
    ///   - writers: Array of writers that messages should be sent to. Default is `ConsoleWriter`
    ///   - modifiers: Array of modifiers that the writer should execute (in order) on incoming messages.
    ///
    /// - Returns: A new `SFLogger` instance.
    public convenience init(logLevels: SFLogLevel = .all,
                            writers: [SFLogWriter],
                            modifiers: [SFLogMessageModifier] = []) {
        self.init(logLevelsValidator: SFContainsLogLevelValidator(logLevels: logLevels),
                  writers: writers,
                  modifiers: modifiers)
    }

}

// MARK: - Log Messages

extension SFLogger {

    /// Writes out the given message using the logger if the debug log level is set.
    ///
    /// - Parameters
    ///   - message: A closure returning the message to log.
    ///   - file: The file in which the call happens.
    ///   - function: The function in which the call happens.
    ///   - line: The line at which the call happens.
    open func debug(_ message: @autoclosure @escaping () -> String,
                    _ file: String = #file,
                    _ function: String = #function,
                    _ line: Int = #line) {
        custom(message, with: SFLogLevel.debug, file, function, line)
    }

    /// Writes out the given message using the logger if the debug log level is set.
    ///
    /// - Parameters
    ///   - message: A closure returning the message to log.
    ///   - file: The file in which the call happens.
    ///   - function: The function in which the call happens.
    ///   - line: The line at which the call happens.
    open func debug(_ message: @escaping () -> String,
                    _ file: String = #file,
                    _ function: String = #function,
                    _ line: Int = #line) {
        custom(message, with: SFLogLevel.debug, file, function, line)
    }

    /// Writes out the given message using the logger if the info log level is set.
    ///
    /// - Parameters
    ///   - message: A closure returning the message to log.
    ///   - file: The file in which the call happens.
    ///   - function: The function in which the call happens.
    ///   - line: The line at which the call happens.
    open func info(_ message: @autoclosure @escaping () -> String,
                   _ file: String = #file,
                   _ function: String = #function,
                   _ line: Int = #line) {
        custom(message, with: SFLogLevel.info, file, function, line)
    }

    /// Writes out the given message using the logger if the info log level is set.
    ///
    /// - Parameters
    ///   - message: A closure returning the message to log.
    ///   - file: The file in which the call happens.
    ///   - function: The function in which the call happens.
    ///   - line: The line at which the call happens.
    open func info(_ message: @escaping () -> String,
                   _ file: String = #file,
                   _ function: String = #function,
                   _ line: Int = #line) {
        custom(message, with: SFLogLevel.info, file, function, line)
    }

    /// Writes out the given message using the logger if the warning log level is set.
    ///
    /// - Parameters
    ///   - message: A closure returning the message to log.
    ///   - file: The file in which the call happens.
    ///   - function: The function in which the call happens.
    ///   - line: The line at which the call happens.
    open func event(_ message: @autoclosure @escaping () -> String,
                    _ file: String = #file,
                    _ function: String = #function,
                    _ line: Int = #line) {
        custom(message, with: SFLogLevel.warning, file, function, line)
    }

    /// Writes out the given message using the logger if the warning log level is set.
    ///
    /// - Parameters
    ///   - message: A closure returning the message to log.
    ///   - file: The file in which the call happens.
    ///   - function: The function in which the call happens.
    ///   - line: The line at which the call happens.
    open func event(_ message: @escaping () -> String,
                    _ file: String = #file,
                    _ function: String = #function,
                    _ line: Int = #line) {
        custom(message, with: SFLogLevel.warning, file, function, line)
    }

    /// Writes out the given message using the logger if the error log level is set.
    ///
    /// - Parameters
    ///   - message: A closure returning the message to log.
    ///   - file: The file in which the call happens.
    ///   - function: The function in which the call happens.
    ///   - line: The line at which the call happens.
    open func error(_ message: @autoclosure @escaping () -> String,
                    _ file: String = #file,
                    _ function: String = #function,
                    _ line: Int = #line) {
        custom(message, with: SFLogLevel.error, file, function, line)
    }

    /// Writes out the given message using the logger if the error log level is set.
    ///
    /// - Parameters
    ///   - message: A closure returning the message to log.
    ///   - file: The file in which the call happens.
    ///   - function: The function in which the call happens.
    ///   - line: The line at which the call happens.
    open func error(_ message: @escaping () -> String,
                    _ file: String = #file,
                    _ function: String = #function,
                    _ line: Int = #line) {
        custom(message, with: SFLogLevel.error, file, function, line)
    }

    /// Writes out the given message using the logger if the severe log level is set.
    ///
    /// - Parameters
    ///   - message: A closure returning the message to log.
    ///   - file: The file in which the call happens.
    ///   - function: The function in which the call happens.
    ///   - line: The line at which the call happens.
    open func severe(_ message: @autoclosure @escaping () -> String,
                     _ file: String = #file,
                     _ function: String = #function,
                     _ line: Int = #line) {
        custom(message, with: SFLogLevel.severe, file, function, line)
    }

    /// Writes out the given message using the logger if the severe log level is set.
    ///
    /// - Parameters
    ///   - message: A closure returning the message to log.
    ///   - file: The file in which the call happens.
    ///   - function: The function in which the call happens.
    ///   - line: The line at which the call happens.
    open func severe(_ message: @escaping () -> String,
                     _ file: String = #file,
                     _ function: String = #function,
                     _ line: Int = #line) {
        custom(message, with: SFLogLevel.severe, file, function, line)
    }

    /// Writes out the given message closure string with the logger if the log level is allowed.
    ///
    /// - Parameters:
    ///   - message: An autoclosure returning the message to log.
    ///   - withLogLevel: The log level associated with the message closure.
    ///   - file: The file in which the call happens.
    ///   - function: The function in which the call happens.
    ///   - line: The line at which the call happens.
    open func custom(_ message: @autoclosure @escaping () -> String,
                     with logLevel: SFLogLevel,
                     _ file: String = #file,
                     _ function: String = #function,
                     _ line: Int = #line) {
        custom(message, with: logLevel, file, function, line)
    }

    /// Writes out the given message closure string with the logger if the log level is allowed.
    ///
    /// - Parameters:
    ///   - message: A closure returning the message to log.
    ///   - withLogLevel: The log level associated with the message closure.
    ///   - file: The file in which the call happens.
    ///   - function: The function in which the call happens.
    ///   - line: The line at which the call happens.
    open func custom(_ message: @escaping () -> String,
                     with logLevel: SFLogLevel,
                     _ file: String = #file,
                     _ function: String = #function,
                     _ line: Int = #line) {
        guard isEnabled && isLogLevelAllowed(logLevel) else {
            return
        }

        // NOTE: runs in own serial background thread for better performance
        if isAsynchronous {
            queue.async { [weak self] in
                guard let self = self else { return }
                let message = self.modify(message(), logLevel: logLevel, file, function, line)
                self.log(message, with: logLevel)
            }
        } else {
            queue.sync { [weak self] in
                guard let self = self else { return }
                let message = self.modify(message(), logLevel: logLevel, file, function, line)
                self.log(message, with: logLevel)
            }
        }
    }

    private func log(_ message: String, with logLevel: SFLogLevel) {
        writers.forEach { $0.log(message, logLevel: logLevel) }
    }

    private func isLogLevelAllowed(_ logLevel: SFLogLevel) -> Bool {
        return logLevelsValidator.isLogLevelAllowed(logLevel)
    }

}

// MARK: - Modifiers

private extension SFLogger {

    func modify(_ message: String,
                logLevel: SFLogLevel,
                _ file: String,
                _ function: String,
                _ line: Int) -> String {
        var message = message
        modifiers.forEach { message = $0.modify(message, with: logLevel, file, function, line) }
        return message
    }
}
