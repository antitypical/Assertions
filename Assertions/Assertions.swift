//  Copyright (c) 2014 Rob Rix. All rights reserved.

// MARK: - Equality

func assertEqual<T: Equatable>(@autoclosure expression1: () -> T?, @autoclosure expression2: () -> T?, _ message: String = "", _ file: String = __FILE__, _ line: UInt = __LINE__) -> T? {
	let (actual, expected) = (expression1(), expression2())
	return actual == expected ? actual : failure("\(actual) is not equal to \(expected). " + message, file: file, line: line)
}


func assertEqual<T: Equatable>(@autoclosure expression1: () -> [T]?, @autoclosure expression2: () -> [T]?, _ message: String = "", _ file: String = __FILE__, _ line: UInt = __LINE__) -> [T]? {
	let (actual, expected) = (expression1(), expression2())
	switch (actual, expected) {
	case (.None, .None):
		return actual
	case let (.Some(x), .Some(y)) where x == y:
		return actual
	default:
		return failure("\(actual) is not equal to \(expected). " + message, file: file, line: line)
	}
}

func assertEqual<T: Hashable, U: Equatable>(@autoclosure expression1: () -> [T: U]?, @autoclosure expression2: () -> [T: U]?, _ message: String = "", _ file: String = __FILE__, _ line: UInt = __LINE__) -> [T: U]? {
	let (actual, expected) = (expression1(), expression2())
	switch (actual, expected) {
	case (.None, .None):
		return actual
	case let (.Some(x), .Some(y)) where x == y:
		return actual
	default:
		return failure("\(actual) is not equal to \(expected). " + message, file: file, line: line)
	}
}


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
