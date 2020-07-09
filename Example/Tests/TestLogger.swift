//
//  TestLogger.swift
//  LoggingKit_Tests
//
//  Created by Aleksandar Sergeev Petrov on 9.07.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
import SFLoggingKit

class TestLogger: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testLoggerShouldCallWritterLogMethod() {
        // given
        let writer = MockWriter()
        let logger = SFLogger(writers: [writer])
        logger.isAsynchronous = false
        // when
        logger.error("Test") // or any other log method
        // then
        XCTAssert(writer.isLogCalled,
                  "Writer log method should be called")
    }

    func testLoggerShouldNotCallWritterLogMethodWhenNotEnabled() {
        // given
        let writer = MockWriter()
        let logger = SFLogger(writers: [writer])
        logger.isAsynchronous = false
        logger.isEnabled = false
        // when
        logger.event("Test") // or any other log method
        // then
        XCTAssertFalse(writer.isLogCalled,
                  "Writer log method should not be called")
    }

    func testLoggerShouldNotCallWritterLogMethodWhenLevelIsNotAllowed() {
        // given
        let writer = MockWriter()
        let validator = MockValidator()
        validator.islAllowed = false
        let logger = SFLogger(logLevelsValidator: validator,
                              writers: [writer])
        logger.isAsynchronous = false
        // when
        logger.debug("Test") // or any other log method
        // then
        XCTAssertFalse(writer.isLogCalled,
                       "Writer log method should not be called")
    }

}

// MARK: - Mocks

final class MockWriter: SFLogWriter {
    var isLogCalled = false

    // MARK: - SFLogWriter

    func log(_ message: String, logLevel: SFLogLevel) {
        isLogCalled = true
    }
}

final class MockValidator: SFLogLevelsValidator {
    var islAllowed = true

    // MARK: - SFLogLevelsValidator

    func isLogLevelAllowed(_ logLevel: SFLogLevel) -> Bool {
        islAllowed
    }
}
