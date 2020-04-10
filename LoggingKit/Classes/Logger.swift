//
//  Logger.swift
//  LoggingKit
//
//  Created by Martin Vasilev on 4.08.18.
//  Copyright © 2018 Upnetix. All rights reserved.
//

import Foundation

open class Logger: LoggingInterface {
    
    public static let shared = Logger()
    
    init() {
        currentLogLevel = .debug
        shouldLogInBackgroundConsole = false
    }
    
    final public var currentLogLevel: LogLevel
    final public var shouldLogInBackgroundConsole: Bool
    
    final public func configure(logLevel: LogLevel, shouldLogInBackgroundConsole: Bool) {
        currentLogLevel = logLevel
        self.shouldLogInBackgroundConsole = shouldLogInBackgroundConsole
    }
    
    final public func log(_ message: String, logLevel: LogLevel) {
        if logLevel.rawValue >= currentLogLevel.rawValue {
            printMessage(message)
        }
    }
    
    private func printMessage(_ message: String) {
        if shouldLogInBackgroundConsole {
            NSLog(message)
        } else {
            print(message)
        }
    }
}
