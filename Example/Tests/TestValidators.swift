//
//  TestValidators.swift
//  LoggingKit_Tests
//
//  Created by Aleksandar Sergeev Petrov on 9.07.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
import SFLoggingKit

class TestValidators: XCTestCase {

    override func setUp() {
        super.setUp()

        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    // MARK: - SFMinimumLogLevelValidator

    func testMinimumLogLevelValidatorInitialization() {
        // given
        let minLevel = SFLogLevel.error
        // when
        let validator = SFMinimumLogLevelValidator(minLevel: .error)
        // then
        XCTAssert(minLevel == validator.minLevel, "Expected log level is: \(minLevel)")
    }

    func testMinimumLogLevelValidationShouldPass() {
        // given
        let level = SFLogLevel.error
        let validator = SFMinimumLogLevelValidator(minLevel: .warning)
        // when
        let result = validator.isLogLevelAllowed(level)
        // then
        XCTAssert(result, "Log level should pass")
    }

    func testMinimumLogLevelValidationShouldNotPass() {
        // given
        let level = SFLogLevel.warning
        let validator = SFMinimumLogLevelValidator(minLevel: .error)
        // when
        let result = validator.isLogLevelAllowed(level)
        // then
        XCTAssertFalse(result, "Log level should not pass")
    }

    // MARK: - SFContainsLogLevelValidator

    func testContainsLogLevelValidatorInitialization() {
        // given
        let levels: SFLogLevel = [SFLogLevel.error, SFLogLevel.warning]
        // when
        let validator = SFContainsLogLevelValidator(
            logLevels: [
                SFLogLevel.error,
                SFLogLevel.warning
            ]
        )
        // then
        XCTAssert(levels == validator.logLevels,
                  "Expected log levels are: \(levels)")
    }

    func testContainsLogLevelValidationShouldPass() {
        // given
        let level = SFLogLevel.error
        let validator = SFContainsLogLevelValidator() // .all
        // when
        let result = validator.isLogLevelAllowed(level)
        // then
        XCTAssert(result, "Log level should pass")
    }

    func testContainsLogLevelValidationShouldNotPass() {
        // given
        let level = SFLogLevel.severe
        let validator = SFContainsLogLevelValidator(
            logLevels: [
                SFLogLevel.error,
                SFLogLevel.warning
            ]
        )
        // when
        let result = validator.isLogLevelAllowed(level)
        // then
        XCTAssertFalse(result, "Log level should not pass")
    }
}
