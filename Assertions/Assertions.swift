//  Copyright (c) 2014 Rob Rix. All rights reserved.

// MARK: - Nil/non-nil

func assertNil<T>(@autoclosure expression: () -> T?, _ message: String = "", file: String = __FILE__, line: UInt = __LINE__) -> Bool {
	return expression().map { failure("\($0) is not nil. " + message, file: file, line: line) } ?? true

}

func assertNotNil<T>(@autoclosure expression: () -> T?, _ message: String = "", file: String = __FILE__, line: UInt = __LINE__) -> T? {
	return expression() ?? failure("is nil. " + message, file: file, line: line)
}


// MARK: - Failure

func failure<T>(message: String, file: String = __FILE__, line: UInt = __LINE__) -> T? {
	XCTFail(message, file: file, line: line)
	return nil
}

func failure(message: String, file: String = __FILE__, line: UInt = __LINE__) -> Bool {
	XCTFail(message, file: file, line: line)
	return false
}


// MARK: - Imports

import XCTest
