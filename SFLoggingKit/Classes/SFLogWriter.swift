//
//  SFLogWriter.swift
//  SFLoggingKit
//
//  Created by Aleksandar Sergeev Petrov on 7.07.20.
//

import Foundation
import os.log

// NOTE: Writers don't append new line automatically.
// If proper add it in log message string

/// The `SFLogWriter` protocol defines a single API for writing a log message. The message can be written in any way the conforming object sees fit.
/// For example, it could write to the console, write to a file, remote log to a third party service, etc.
public protocol SFLogWriter {

    func log(_ message: String, logLevel: SFLogLevel)
}

// MARK: - Xcode Console

/// The SFConsoleLogWriter class runs all modifiers in the order they were created and prints the resulting message  to the Xcode console.
open class SFConsoleLogWriter: SFLogWriter {

    // MARK: - Properties

    /// Determines if the logs should be visible when attatching a device and debugging in the console
    private let shouldLogInBackgroundConsole: Bool

    // MARK: - Initializers

    /// Initializes a console writer instance.
    ///
    /// - Parameter shouldLogInBackgroundConsole: The function to use when logging to the console. Defaults to `print`.
    ///
    /// - Returns: A new console writer instance.
    public init(shouldLogInBackgroundConsole: Bool = false) {
        self.shouldLogInBackgroundConsole = shouldLogInBackgroundConsole
    }

    // MARK: - SFLogWriter

    /// Writes the message to the console using the global `print` or `NSLog`  function.
    ///
    /// Modifier is run over the message in the order to provide log level before writing the message to
    /// the console.
    ///
    /// - Parameters:
    ///   - message: The original message to write to the console.
    ///   - logLevel: The log level associated with the message.
    open func log(_ message: String, logLevel: SFLogLevel) {
        if shouldLogInBackgroundConsole {
            NSLog(message)
        } else {
            print(message)
        }
    }

}

// MARK: - OSLog

/// The `SFSystemLogWriter` class runs all modifiers in the order they were created and passes the resulting message
/// off to an `OSLog` with the specified subsystem and category.
open class SFSystemLogWriter: SFLogWriter {

    // MARK: - Properties

    public let subsystem: String
    public let category: String

    // MARK: - Initializers

    /// Creates an `SFSystemLogWriter` instance from the specified `subsystem` and `category`.
    ///
    /// - Parameters:
    ///   - subsystem: The subsystem. Default is app bundle identifier
    ///   - category: The category. E.g. `ui`, `firebase`, `networking`, etc.
    ///
    /// - Returns: A new `SFSystemLogWriter` instance.
    public init(subsystem: String = Bundle.main.bundleIdentifier!, category: String) {
        self.subsystem = subsystem
        self.category = category
        self.log = OSLog(subsystem: subsystem, category: category)
    }

    // MARK: - SFLogWriter

    /// Writes the message to the `OSLog` using the `os_log` function.
    ///
    /// - Parameters:
    ///   - message: The original message to write to the console.
    ///   - logLevel: The log level associated with the message.
    open func log(_ message: String, logLevel: SFLogLevel) {
        // get mathcing os_log log type
        let type = logType(forLogLevel: logLevel)
        os_log("%@", log: log, type: type, message)
    }

    // MARK: - OSLog

    private let log: OSLog

    /// Returns the `OSLogType` to use for the specified `SFLogLevel`.
    ///
    /// - Parameter logLevel: The level to be map to a `OSLogType`.
    ///
    /// - Returns: An `OSLogType` corresponding to the `SFLogLevel`.
    open func logType(forLogLevel logLevel: SFLogLevel) -> OSLogType {
        switch logLevel {
        case SFLogLevel.debug:      return .debug
        case SFLogLevel.info:       return .info
        case SFLogLevel.warning:    return .default
        case SFLogLevel.error:      return .error
        case SFLogLevel.severe:     return .fault
        default:                    return .default
        }
    }

}

// MARK: - File

/// TBD: Documentation
public protocol SFFileWritable {

    func write(_ text: String) throws
}

/// TBD: Documentation
public enum SFFileWriteError: Error {

    case convertToDataIssue
    case fileNotFound
}

/// The SFFileLogWriter class runs all modifiers in the order they were created and prints the resulting message to a file.
open class SFFileLogWriter: SFLogWriter, SFFileWritable {

    // MARK: - Properties

    public let encoding: String.Encoding
    public let fileUrl: URL

    // MARK: - Initializers

    /// Initializes a file writer instance.
    ///
    /// - Parameter fileUrl:    The path to the file.
    /// - Parameter encoding:   The encoding used to convert log message into data before writing. Default is utf8.
    ///
    /// - Returns: A new file writer instance.
    public init(fileUrl: URL, encoding: String.Encoding = .utf8) {
        self.fileUrl = fileUrl
        self.encoding = encoding
    }

    // MARK: - SFLogWriter

    /// Writes the message to the console using the global `print` or `NSLog`  function.
    ///
    /// Modifier is run over the message in the order to provide log level before writing the message to the console.
    ///
    /// - Parameters:
    ///   - message: The original message to write to the console.
    ///   - logLevel: The log level associated with the message.
    open func log(_ message: String, logLevel: SFLogLevel) {
        do {
            try write(message)
        } catch {
            // NOTE: Do something
        }
    }

    // MARK: - SFFileWritable

    /// Writes text to end of the log file.
    ///
    /// - Parameter text:   The text that should be added to a file.
    public func write(_ text: String) throws {
        guard let data = text.data(using: encoding) else {
            throw SFFileWriteError.convertToDataIssue
        }

        guard let fileHandle = LogFileHandle(filePath: fileUrl.path, appending: true) else {
            throw SFFileWriteError.fileNotFound
        }

        fileHandle.write(data)
    }

}

/// The` SFRotatingFileLogWriter` class runs all modifiers in the order they were created and writes the resulting message
/// to  a set of numbered files. Once a file has reached its maximum file size, the writer automatically rotates to the next file in the set.
open class SFRotatingFileLogWriter: SFFileLogWriter {

    // MARK: - Properties

    /// The maximum allowed file size in bytes.
    let maxFileSize: UInt

    /// The number of files to include in the rotating set.
    let numberOfFiles: UInt

    // MARK: - Initializers

    /// Initializes a file writer instance.
    ///
    /// - Parameter fileUrl:        The URL used to build the rotating file set’s file URLs. Each file's index
    ///                             number will be prepended to the last path component of this URL.
    /// - Parameter encoding:       The encoding used to convert log message into data before writing. Default is utf8.
    /// - Parameter numberOfFiles:  The number of files to be used in the rotation. Defaults to `4`.
    /// - Parameter maxFileSize:    The maximum file size of each file in the rotation, specified in megabytes. Defaults to 1 MB.
    ///
    /// - Returns: A new file writer instance.
    public init?(fileUrl: URL, encoding: String.Encoding = .utf8, numberOfFiles: UInt = 4, maxFileSize: UInt = 1) {
        guard (1...UInt.max).contains(maxFileSize) else {
            assertionFailure("The max file size should lie inside the range: 1...\(UInt.max)")
            return nil
        }

        self.numberOfFiles = numberOfFiles
        self.maxFileSize = maxFileSize * 1024 * 1024

        super.init(fileUrl: fileUrl, encoding: encoding)
    }

    // MARK: - SFFileWritable

    /// Writes text to the current log file.
    ///
    /// - Parameter text:   The text that should be added to a file.
    public override func write(_ text: String) throws {
        guard let data = text.data(using: encoding) else {
            throw SFFileWriteError.convertToDataIssue
        }

        if shouldRotateFilesBeforeWritingDataWithLength(data.count) {
            let fileHandle = nextFileHandle(appending: false)
            rotateToFile(nextFileHandle: fileHandle)
        }

        guard let fileHandle = currentFileHandle else {
            throw SFFileWriteError.fileNotFound
        }

        fileHandle.write(data)
    }

    // MARK: - File Rotating

    /// The file currently being written to.
    private lazy var currentFileHandle: LogFileHandle? = nextFileHandle(appending: true)

    /// The index of the current file from the rotating set.
    private lazy var currentIndex: UInt = findCurrentIndex()

    /// The URL of the directory in which the set of log files is located.
    private var directoryUrl: URL {
        fileUrl.deletingLastPathComponent()
    }

    /// The base file name of the log files.
    private var baseFileName: String {
        fileUrl.lastPathComponent
    }

    /// The URL of the log file currently in use.
    public var currentURL: URL {
        fileUrl(at: self.currentIndex)
    }

    /// The URL of the next file in the rotation.
    private var nextURL: URL {
        fileUrl(at: self.nextIndex)
    }

    /// The index of the next file in the rotation.
    private var nextIndex: UInt {
        let nextIndex = currentIndex + 1
        return nextIndex > numberOfFiles ? 1 : nextIndex
    }

    /// The name for the file at a given index.
    private func fileName(at index: UInt) -> String {
        let format = "%0\(Int(floor(log10(Double(self.numberOfFiles)) + 1.0)))d"
        return "\(String(format: format, index))_\(self.baseFileName)"
    }

    /// The URL for the file at a given index.
    private func fileUrl(at index: UInt) -> URL {
        let fileName = self.fileName(at: index)
        return directoryUrl.appendingPathComponent(fileName, isDirectory: false)
    }

    /// The next log file to be written to, already prepared for use.
    private func nextFileHandle(appending: Bool) -> LogFileHandle? {
        guard let fileHandle = LogFileHandle(filePath: nextURL.path, appending: appending) else {
            assertionFailure("The log file at URL '\(nextURL)' could not be opened.")
            return nil
        }
        return fileHandle
    }

    /// Sets the current file to the next index.
    private func rotateToFile(nextFileHandle: LogFileHandle?) {
        currentFileHandle = nextFileHandle
        currentIndex = nextIndex
    }

    /// - The goal here is to find the index of the file in the set that was last modified
    /// (has the largest `modified` timestamp). If no file returns a `modified` property,
    /// it's probably because no files in this set exist yet, in which case we'll just return index 1.
    ///
    /// - returns An integer value indicating the index of the current file
    private func findCurrentIndex() -> UInt {
        Array(1...self.numberOfFiles)
            .compactMap { (index) -> (index: UInt, modified: TimeInterval) in
                let modified = (try? self.fileUrl(at: index)
                    .resourceValues(forKeys: [URLResourceKey.contentModificationDateKey])
                    .contentModificationDate) ?? Date.distantPast
                return (index: index, modified: modified.timeIntervalSinceReferenceDate)
            }
            .max {
                $0.modified <= $1.modified
            }?
            .index ?? 1
    }

    /// This method provides an opportunity to determine whether a new log file should be selected before
    /// writing the next Log Entry.
    ///
    /// - parameter length: The length of the data (number of bytes) that will be written next.
    ///
    /// - returns: A boolean indicating whether a new log file should be selected.
    private func shouldRotateFilesBeforeWritingDataWithLength(_ length: Int) -> Bool {
        guard let currentSize = currentFileHandle?.bytesCount else {
            // Can't determine current size
            return true
        }
        return currentSize + UInt64(length) > maxFileSize
    }

}

private final class LogFileHandle {

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

// MARK: - Terminal Console

// TODO:
