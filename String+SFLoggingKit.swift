//
//  String+SFLoggingKit.swift
//  SFLoggingKit
//
//  Created by Aleksandar Sergeev Petrov on 23.11.21.
//

import Foundation

/// String syntax sugar extension
extension String {

    var ns: NSString {
        return self as NSString
    }

    var lastPathComponent: String {
        return ns.lastPathComponent
    }

    var stringByDeletingPathExtension: String {
        return ns.deletingPathExtension
    }

    var deletingLastPathComponent: String {
        ns.deletingLastPathComponent
    }
}
