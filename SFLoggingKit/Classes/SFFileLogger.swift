//
//  FileLogger.swift
//  SFLoggingKitDemo
//
//  Created by Aleksandar Gyuzelov on 9.04.20.
//  Copyright © 2020 Aleksandar Gyuzelov. All rights reserved.
//

import Foundation

struct SFFileLogger: TextOutputStream {
    
    static var shared: SFFileLogger = SFFileLogger()
    
    private init() {}
    
    var documentDirectoryPath = ""
    
    var logFileName = ""
    
    private var logFileFullPath: String { return documentDirectoryPath+logFileName }
    
    lazy var fileHandle: FileHandle? = {
        if !FileManager.default.fileExists(atPath: logFileFullPath) {
            FileManager.default.createFile(atPath: logFileFullPath, contents: nil, attributes: nil)
        }
        let fileHandle = FileHandle(forWritingAtPath: logFileFullPath)
        return fileHandle
    }()
    
    mutating func write(_ string: String) {
        fileHandle?.seekToEndOfFile()
        if let dataToWrite = string.data(using: String.Encoding.utf8) {
            fileHandle?.write(dataToWrite)
        }
        
    }
}
