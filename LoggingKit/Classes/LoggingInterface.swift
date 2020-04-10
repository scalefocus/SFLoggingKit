//
//  LoggingInterface.swift
//  LoggingKit
//
//  Created by Martin Vasilev on 4.08.18.
//  Copyright © 2018 Upnetix. All rights reserved.
//

import Foundation

/// The different Loglevels
///
/// - debug: Should be used for debug purposes
/// - info: Should be used to log valuable information (possibly for testing on live)
/// - warning: Should log various warnings or not very significant errors
/// - error: Should log errors (Server errors, library failures and so on)
/// - severe: Should log severe errors, crashes possibly or catching serious exceptions
public enum LogLevel: Int {
    case debug = 0
    case info
    case warning
    case error
    case severe
}

public protocol LoggingInterface {
    /// The log level at which logs will be visible
    var currentLogLevel: LogLevel {get set}
    
    /// Determines if the logs should be visible when attatching a device and debugging in the console
    var shouldLogInBackgroundConsole: Bool {get set}
    
    /// Configures the current log level
    ///
    /// - Parameters:
    ///   - logLevel: Current log level that will be visible
    ///   - shouldLogInBackgroundConsole: Should logs be visible in the attatched console
    func configure(logLevel: LogLevel, shouldLogInBackgroundConsole: Bool)
    
    /// Log a message with specific log level. It should be logged ONLY if the log level is the same
    /// or higher than the current log level of the LoggingInterface
    /// - Parameters:
    ///   - message: The message to log
    ///   - logLevel: The log level of the message
    func log(_ message: String, logLevel: LogLevel)
}
