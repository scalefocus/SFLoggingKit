//
//  LoggerConfiguration.swift
//  SFLoggingKitDemo
//
//  Created by Aleksandar Gyuzelov on 9.04.20.
//  Copyright © 2020 Aleksandar Gyuzelov. All rights reserved.
//

import Foundation

public protocol SFLoggerConfigurationProtocol {
    
    /// Allows writing to a console, depending on the environment and log level
    /// - Parameter logLevel: The log level on which basis the decision will be made
    func allowToPrint(logLevel: SFLogLevel) -> Bool
    
    /// Allows writing to a file, depending on the environment and log level
    /// - Parameter logLevel: The log level on which basis the decision will be made
    func allowToLogWrite(logLevel: SFLogLevel) -> Bool
    
    /// Configures the timestamp usage
    var isTimeStampDisplayed: Bool { get }
    
    /// Configures how timestamp will be formatted
    var timeFormatter: DateFormatter { get }
    
    /// Configures the file name usage
    var isFileNameDisplayed: Bool { get }
    
    /// Configures the function name usage
    var isFunctionNameDisplayed: Bool { get }
    
    /// Configures the line number usage
    var isLineNumberDisplayed: Bool { get }
    
    /// The name of the file that will be used if writing to a file is allowed
    var logFileName: String { get }
    
    /// Thе directory path, where the file will be saved
    var documentDirectoryPath: String { get }
    
}

extension SFLoggerConfigurationProtocol {
    
    public var isTimeStampDisplayed: Bool { return true }
    
    public var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: Calendar.Identifier.iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSX"
        return formatter
    }
    
    public var isFileNameDisplayed: Bool { return true }
    
    public var isFunctionNameDisplayed: Bool { return true }
    
    public var isLineNumberDisplayed: Bool { return true }
    
    public var logFileName: String { return  "\(timeFormatter.string(from: Date()))SFLogger.txt" }
    
    public var documentDirectoryPath: String { return NSHomeDirectory() + "/Documents/" }
    
    public func allowToPrint(logLevel: SFLogLevel) -> Bool {
        #if DEBUG
        return true
        #elseif RELEASE
        switch logType {
        case .INFO, .DEBUG, .WARNING:
            return false
        case .ERROR, .EXCEPTION:
            return true
        }
        
        #endif
    }
    
    public func allowToLogWrite(logLevel: SFLogLevel) -> Bool {
        #if DEBUG
        return true
        #elseif RELEASE
        switch logType {
        case .INFO, .DEBUG:
            return true
        case .WARNING, .ERROR, .EXCEPTION:
            return true
        }
        #endif
    }
   
}

struct SFBaseLoggerConfiguration: SFLoggerConfigurationProtocol {
    
}
