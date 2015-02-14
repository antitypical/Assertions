//  Copyright (c) 2014 Rob Rix. All rights reserved.

// MARK: - Equality

/// Asserts the equality of two Equatable values.
///
/// Returns the value, if equal and non-nil.
public func assertEqual<T: Equatable>(@autoclosure expression1: () -> T?, @autoclosure expression2: () -> T?, _ message: String = "", _ file: String = __FILE__, _ line: UInt = __LINE__) -> T? {
	return assertEqual(expression1(), { $0 == $1 }, expression2(), message, file, line)
}


/// Asserts the equality of two arrays of Equatable values.
///
/// Returns the array, if equal and non-nil.
public func assertEqual<T: Equatable>(@autoclosure expression1: () -> [T]?, @autoclosure expression2: () -> [T]?, _ message: String = "", _ file: String = __FILE__, _ line: UInt = __LINE__) -> [T]? {
	return assertEqual(expression1(), ==, expression2(), message, file, line)
}


/// Asserts the equality of two dictionaries of Equatable values.
///
/// Returns the dictionary, if equal and non-nil.
public func assertEqual<T: Hashable, U: Equatable>(@autoclosure expression1: () -> [T: U]?, @autoclosure expression2: () -> [T: U]?, _ message: String = "", _ file: String = __FILE__, _ line: UInt = __LINE__) -> [T: U]? {
	return assertEqual(expression1(), ==, expression2(), message, file, line)
}


// MARK: - Nil/non-nil

/// Asserts that a value is nil.
public func assertNil<T>(@autoclosure expression: () -> T?, _ message: String = "", file: String = __FILE__, line: UInt = __LINE__) -> Bool {
	return expression().map { failure("\($0) is not nil. " + message, file: file, line: line) } ?? true
}

/// Asserts that a value is not nil.
public func assertNotNil<T>(@autoclosure expression: () -> T?, _ message: String = "", file: String = __FILE__, line: UInt = __LINE__) -> T? {
	return expression() ?? failure("is nil. " + message, file: file, line: line)
}


// MARK: - Failure

/// Logs a failed assertion.
///
/// Returns nil, for use in `x ?? failure(…)` expressions.
public func failure<T>(message: String, file: String = __FILE__, line: UInt = __LINE__) -> T? {
	XCTFail(message, file: file, line: line)
	return nil
}

/// Logs a failed assertion.
///
/// Returns nil, for use in `x ?? failure(…)` expressions.
public func failure(message: String, file: String = __FILE__, line: UInt = __LINE__) -> Bool {
	XCTFail(message, file: file, line: line)
	return false
}


// MARK: - Implementation details

private func assertEqual<T>(actual: T?, equal: (T, T) -> Bool, expected: T?, message: String, file: String, line: UInt) -> T? {
	switch (actual, expected) {
	case (.None, .None):
		return actual
	case let (.Some(x), .Some(y)) where equal(x, y):
		return actual
	default:
		return failure("\(actual) is not equal to \(expected). " + message, file: file, line: line)
	}
}


// MARK: - Imports

import XCTest
