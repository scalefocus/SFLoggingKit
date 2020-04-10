//
//  ViewController.swift
//  SFLoggingKitDemo
//
//  Created by Aleksandar Gyuzelov on 9.04.20.
//  Copyright © 2020 Aleksandar Gyuzelov. All rights reserved.
//

import UIKit
import SFLoggingKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Default
        var withoutTimeStampLogger = SFLogger.shared
        withoutTimeStampLogger.configuration = SFWithoutTimeStampConfiguration()
        SFLogger.shared.log("Log Message", logLevel: .debug)
        SFLogger.shared.log("Log Message", logLevel: .error)
        SFLogger.shared.log("Log Message", logLevel: .exception)
        SFLogger.shared.log("Log Message", logLevel: .info)
        SFLogger.shared.log("Log Message", logLevel: .warning)
        
        // Without time stamp
        withoutTimeStampLogger.log("Log Message", logLevel: .debug)
        withoutTimeStampLogger.log("Log Message", logLevel: .error)
        withoutTimeStampLogger.log("Log Message", logLevel: .exception)
        SFLogger.shared.log("Log Message", logLevel: .exception)
        withoutTimeStampLogger.log("Log Message", logLevel: .exception)
        withoutTimeStampLogger.log("Log Message", logLevel: .info)
        withoutTimeStampLogger.log("Log Message", logLevel: .warning)
        
        // Global logger with changed configurations
        SFLogger.shared.configuration = SFHoursLogConfiguration()
        SFLogger.shared.log("Log Message", logLevel: .debug)
        SFLogger.shared.log("Log Message", logLevel: .error)
        SFLogger.shared.log("Log Message", logLevel: .exception)
        SFLogger.shared.log("Log Message")
        SFLogger.shared.log("Log sMessage", logLevel: .warning)
    }
    
}

struct SFWithoutTimeStampConfiguration: SFLoggerConfigurationProtocol {
    public var isTimeStampDisplayed: Bool { return false }
    public var isFileNameDisplayed: Bool { return true }
    public var isFunctionNameDisplayed: Bool { return true }
    public var isLineNumberDisplayed: Bool { return true }
    public func allowToPrint(logLevel: SFLogLevel) -> Bool {
        #if DEBUG
        return true
        #elseif RELEASE
        switch logType {
        case .DEBUG, .WARNING, .INFO:
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
        case .DEBUG, .INFO:
            return false
        case .ERROR, .EXCEPTION, .WARNING:
            return true
        }
        #endif
    }
}

struct SFOnlyLineNumberLogConfiguration: SFLoggerConfigurationProtocol {
    public var isTimeStampDisplayed: Bool { return false }
    public var isFileNameDisplayed: Bool { return false }
    public var isFunctionNameDisplayed: Bool { return false }
    public var isLineNumberDisplayed: Bool { return true }
    public func allowToPrint(logLevel: SFLogLevel) -> Bool {
        #if DEBUG
        return true
        #elseif RELEASE
        switch logType {
        case .DEBUG, .WARNING, .INFO:
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
        case .DEBUG, .INFO:
            return true
        case .ERROR, .EXCEPTION, .WARNING:
            return true
        }
        #endif
    }
}

struct SFHoursLogConfiguration: SFLoggerConfigurationProtocol {
    public var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: Calendar.Identifier.iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }
    
}
