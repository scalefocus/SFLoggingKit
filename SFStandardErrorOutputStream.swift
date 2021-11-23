//
//  SFStandardErrorOutputStream.swift
//  SFLoggingKit
//
//  Created by Aleksandar Sergeev Petrov on 23.11.21.
//

import Foundation

public final class SFStandardErrorOutputStream: TextOutputStream {

    // MARK: - Properties

    private let fileHandle: FileHandle = FileHandle.standardError

    // MARK: - TextOutputStream

    public func write(_ string: String) {
        fileHandle.write(Data(string.utf8))
    }

}
