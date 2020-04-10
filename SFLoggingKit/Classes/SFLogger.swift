//
//  SFLogger.swift
//  SFLoggingKitDemo
//
//  Created by Aleksandar Gyuzelov on 10.04.20.
//  Copyright © 2020 Aleksandar Gyuzelov. All rights reserved.
//

import Foundation

public struct SFLogger {
    
    public static var shared = SFLogger()
    
    public var configuration: SFLoggerConfigurationProtocol = SFBaseLoggerConfiguration()
    
    public func log(_ message: Any..., logLevel: SFLogLevel = .info, _ callingFunctionName: String = #function, _ lineNumber: UInt = #line, _ fileName: String = #file) {
        let messageString = message.map({"\($0)"}).joined(separator: " ")
        var fullMessageString = logLevel.symbolString()
        
        if configuration.isTimeStampDisplayed {
            fullMessageString += configuration.timeFormatter.string(from: Date()) + " ⇨ "
        }
        if configuration.isFileNameDisplayed {
            let fileName = URL(fileURLWithPath: fileName).deletingPathExtension().lastPathComponent
            fullMessageString += fileName + " ⇨ "
        }
        if configuration.isFunctionNameDisplayed {
            fullMessageString += callingFunctionName + " ⇨ "
        }
        
        if configuration.isLineNumberDisplayed {
            fullMessageString.removeLast(3)
            fullMessageString += " : \(lineNumber)" + " ⇨ "
        }
        
        fullMessageString += messageString
        
        if configuration.allowToPrint(logLevel: logLevel) {
            print(fullMessageString)
        }
        if configuration.allowToLogWrite(logLevel: logLevel) {
            var fileLogger = SFFileLogger.shared
            fileLogger.documentDirectoryPath = configuration.documentDirectoryPath
            fileLogger.logFileName = configuration.logFileName
            print(fullMessageString, to: &fileLogger)
        }
    }
    
}

