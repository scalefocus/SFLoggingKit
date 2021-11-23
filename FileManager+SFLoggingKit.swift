//
//  FileManager+SFLoggingKit.swift
//  SFLoggingKit
//
//  Created by Aleksandar Sergeev Petrov on 23.11.21.
//

import Foundation

extension FileManager {

    func ensureFileExists(_ filePath: String) throws {
        guard !fileExists(atPath: filePath) else {
            return
        }

        let directoryPath = filePath.deletingLastPathComponent
        try ensureDirectoryExists(directoryPath)

        guard createFile(atPath: filePath, contents: nil, attributes: nil) else {
            throw NSError(domain: NSURLErrorDomain,
                          code: NSURLErrorCannotCreateFile,
                          userInfo: [NSURLErrorKey: filePath])
        }
    }

    private func ensureDirectoryExists(_ directoryPath: String) throws {
        guard !fileExists(atPath: directoryPath) else {
            return
        }
        try createDirectory(atPath: directoryPath, withIntermediateDirectories: true)
    }

}
