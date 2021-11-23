//
//  SFLogLevelsValidator.swift
//  SFLoggingKit
//
//  Created by Aleksandar Sergeev Petrov on 7.07.20.
//

import Foundation

/// The `SFLogLevelsValidator` protocol defines a single method for validating if log level is valid to generate output.
public protocol SFLogLevelsValidator {

    func isLogLevelAllowed(_ logLevel: SFLogLevel) -> Bool
}

// MARK: - Concrete Validators

public final class SFMinimumLogLevelValidator: SFLogLevelsValidator {

    // MARK: - Properties

    /// The minimum level of severity.
    public let minLevel: SFLogLevel

    // MARK: - Initialization

    /// Initializes a validator instance.
    ///
    /// - Parameters:
    ///   - minLevel: The message levels filter. Default is `.debug`
    ///
    /// - Returns: A new `SFMinimumLogLevelValidator` instance.
    public init(minLevel: SFLogLevel = .debug) {
        self.minLevel = minLevel
    }

    // MARK: - ValidateLogLevel

    public func isLogLevelAllowed(_ logLevel: SFLogLevel) -> Bool {
        return logLevel.rawValue >= minLevel.rawValue
    }

}

public final class SFContainsLogLevelValidator: SFLogLevelsValidator {

    // MARK: - Properties

    /// Log levels this logger is configured for.
    public let logLevels: SFLogLevel

    // MARK: - Initialization

    /// Initializes a validator instance.
    ///
    /// - Parameters:
    ///   - logLevels: The message levels that should be logged to the writers. Default is `.all`
    ///
    /// - Returns: A new `SFContainsLogLevelValidator` instance.
    public init(logLevels: SFLogLevel = .all) {
        self.logLevels = logLevels
    }

    // MARK: - ValidateLogLevel

    public func isLogLevelAllowed(_ logLevel: SFLogLevel) -> Bool {
        return logLevels.contains(logLevel)
    }
    
}
