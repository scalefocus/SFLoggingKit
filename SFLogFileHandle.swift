//
//  SFLogFileHandle.swift
//  SFLoggingKit
//
//  Created by Aleksandar Sergeev Petrov on 23.11.21.
//

import Foundation

final class SFLogFileHandle {

    // MARK: - Properties

    private let fileManager = FileManager.default
    private let fileHandle: FileHandle

    private var currentByteOffset: UInt64

    /// The size of this log file in bytes.
    var bytesCount: UInt64 {
        currentByteOffset
    }

    /// Initialize a log file handle. Fails if the file cannot be accessed.
    ///
    /// - parameter filePath:   The absolute path to the log file.
    /// - parameter appending:  Indicates whether new data should be appended to existing data in the file,
    ///                         or if the file should be truncated when opened.
    ///
    init?(filePath: String, appending: Bool) {
        do {
            try fileManager.ensureFileExists(filePath)
        } catch {
            return nil
        }

        guard let fileHandle = FileHandle(forWritingAtPath: filePath) else {
            return nil
        }

        self.fileHandle = fileHandle

        if appending {
            currentByteOffset = fileHandle.seekToEndOfFile()
        } else {
            fileHandle.truncateFile(atOffset: 0)
            currentByteOffset = 0
        }
    }

    deinit {
        // clean up
        fileHandle.synchronizeFile()
        fileHandle.closeFile()
    }

    /// Write data to this log file.
    func write(_ data: Data) {
        fileHandle.write(data)
        currentByteOffset += UInt64(data.count)
    }

}
