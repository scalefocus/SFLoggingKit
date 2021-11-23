//
//  Formatter+SFLoggingKit.swift
//  SFLoggingKit
//
//  Created by Aleksandar Sergeev Petrov on 23.11.21.
//

import Foundation

/// Default log timestamp formatter sugar extension
public extension Formatter {

    static var logTimestampFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return formatter
    }()
}
