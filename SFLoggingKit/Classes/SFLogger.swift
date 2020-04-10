//
//  SFLogger.swift
//  SFLoggingKit
//
//  Created by Martin Vasilev on 4.08.18.
//  Copyright © 2018 Upnetix. All rights reserved.
//

import Foundation

open class SFLogger: SFLoggingInterface {
    
    public static let shared = SFLogger()
    
    init() {
        currentLogLevel = .debug
        shouldLogInBackgroundConsole = false
    }
    
    final public var currentLogLevel: SFLogLevel
    final public var shouldLogInBackgroundConsole: Bool
    
    final public func configure(logLevel: SFLogLevel, shouldLogInBackgroundConsole: Bool) {
        currentLogLevel = logLevel
        self.shouldLogInBackgroundConsole = shouldLogInBackgroundConsole
    }
    
    final public func log(_ message: String, logLevel: SFLogLevel) {
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
