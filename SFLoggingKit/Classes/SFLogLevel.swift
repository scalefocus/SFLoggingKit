//
//  SFLogType.swift
//  SFLoggingKitDemo
//
//  Created by Aleksandar Gyuzelov on 10.04.20.
//  Copyright © 2020 Aleksandar Gyuzelov. All rights reserved.
//

import Foundation

public enum SFLogLevel {
    case info
    case debug
    case warning
    case error
    case exception
    
    public func symbolString() -> String {
        var logLevelSign = ""
        switch self {
        case .info:
            logLevelSign =  "\u{0001F538} "
        case .debug:
            logLevelSign =  "\u{0001F539} "
        case .warning:
        logLevelSign =  "\u{26A0}\u{FE0F} "
        case .error:
            logLevelSign =  "\u{0001F6AB} "
        case .exception:
            logLevelSign =  "\u{2757}\u{FE0F} "
        }
        let logLevelString = "\(self)"
        return logLevelSign + logLevelString.uppercased() + String(repeating: " ", count: (10 - logLevelString.count)) + "➯ "
    }
}
