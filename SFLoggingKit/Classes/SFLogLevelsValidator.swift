//
//  SFLogLevelsValidator.swift
//  SFLoggingKit
//
//  Created by Aleksandar Sergeev Petrov on 7.07.20.
//

import Foundation

// NOTE: Strategy pattern
public protocol SFLogLevelsValidator {
    func isLogLevelAllowed(_ logLevel: SFLogLevel) -> Bool
}

public final class SFMinimumLogLevelValidator: SFLogLevelsValidator {
    /// The minimum level of severity.
    public let minLevel: SFLogLevel

    // MARK: - Initialization

    /// Initializes a validator instance.
    ///
    /// - Parameters:
    ///   - minLevel: The message levels filter. Default is `.debug`
    public init(minLevel: SFLogLevel = .debug) {
        self.minLevel = minLevel
    }

    // MARK: - ValidateLogLevel

    public func isLogLevelAllowed(_ logLevel: SFLogLevel) -> Bool {
        return logLevel.rawValue >= minLevel.rawValue
    }
}

public final class SFContainsLogLevelValidator: SFLogLevelsValidator {
    /// Log levels this logger is configured for.
    public let logLevels: SFLogLevel

    // MARK: - Initialization

    /// Initializes a validator instance.
    ///
    /// - Parameters:
    ///   - logLevels: The message levels that should be logged to the writers. Default is `.all`
    public init(logLevels: SFLogLevel = .all) {
        self.logLevels = logLevels
    }

    // MARK: - ValidateLogLevel

    public func isLogLevelAllowed(_ logLevel: SFLogLevel) -> Bool {
        return logLevels.contains(logLevel)
    }
}
