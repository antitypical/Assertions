//  Copyright (c) 2014 Rob Rix. All rights reserved.

// MARK: - Matching

/// Asserts that a binary function matches two operands.
///
/// This is useful for asserting the equality of collections which only define equality for Equatable element types.
///
///		assert(x, ==, y)
public func assert<T, U>(@autoclosure expression1: () -> T?, test: (T, U) -> Bool, @autoclosure expression2: () -> U?, message: String = "", file: String = __FILE__, line: UInt = __LINE__) -> T? {
	return assertExpected(expression1(), test, expression2(), message, file, line)
}

/// Asserts that a curried binary function matches two operands.
///
/// This is useful for asserting that some method applies to the receiver on the left and the operand on the right.
///
///		assert(Set([ 1, 2, 3 ]), Set.contains, 3)
public func assert<T, U>(@autoclosure expression1: () -> T?, test: T -> U -> Bool, @autoclosure expression2: () -> U?, message: String = "", file: String = __FILE__, line: UInt = __LINE__) -> T? {
	return assertExpected(expression1(), { x, y in test(x)(y) }, expression2(), message, file, line)
}

/// Asserts the truth of a predicate applied to a value.
///
/// This is useful for asserting that a value has some property or other.
///
///		assert("", { $0.isEmpty })
public func assert<T>(@autoclosure expression: () -> T?, test: T -> Bool, message: String = "", file: String = __FILE__, line: UInt = __LINE__) -> T? {
	return assertPredicate(expression(), test, message, file, line)
}


// MARK: - Equality

/// Asserts the equality of two Equatable values.
///
/// Returns the value, if equal and non-nil.
public func assertEqual<T: Equatable>(@autoclosure expression1: () -> T?, @autoclosure expression2: () -> T?, _ message: String = "", _ file: String = __FILE__, _ line: UInt = __LINE__) -> T? {
	return assertExpected(expression1(), { $0 == $1 }, expression2(), message, file, line)
}


/// Asserts the equality of two arrays of Equatable values.
///
/// Returns the array, if equal and non-nil.
public func assertEqual<T: Equatable>(@autoclosure expression1: () -> [T]?, @autoclosure expression2: () -> [T]?, _ message: String = "", _ file: String = __FILE__, _ line: UInt = __LINE__) -> [T]? {
	return assertExpected(expression1(), ==, expression2(), message, file, line)
}


/// Asserts the equality of two dictionaries of Equatable values.
///
/// Returns the dictionary, if equal and non-nil.
public func assertEqual<T: Hashable, U: Equatable>(@autoclosure expression1: () -> [T: U]?, @autoclosure expression2: () -> [T: U]?, _ message: String = "", _ file: String = __FILE__, _ line: UInt = __LINE__) -> [T: U]? {
	return assertExpected(expression1(), ==, expression2(), message, file, line)
}


// MARK: - Nil/non-nil

/// Asserts that a value is nil.
public func assertNil<T>(@autoclosure expression: () -> T?, _ message: String = "", file: String = __FILE__, line: UInt = __LINE__) -> Bool {
	return assertPredicate(expression(), { $0 == nil }, "is not nil. " + message, file, line) == nil
}

/// Asserts that a value is not nil.
public func assertNotNil<T>(@autoclosure expression: () -> T?, _ message: String = "", file: String = __FILE__, line: UInt = __LINE__) -> T? {
	return assertPredicate(expression(), { $0 != nil }, "is nil. " + message, file, line)
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

private func assertPredicate<T>(actual: T?, predicate: T -> Bool, message: String, file: String, line: UInt) -> T? {
	return actual.map { predicate($0) ? actual : nil } ?? failure(message, file: file, line: line)
}

private func assertExpected<T, U>(actual: T?, match: (T, U) -> Bool, expected: U?, message: String, file: String, line: UInt) -> T? {
	switch (actual, expected) {
	case (.None, .None):
		return actual
	case let (.Some(x), .Some(y)) where match(x, y):
		return actual
	default:
		return failure("\(actual) did not match \(expected). " + message, file: file, line: line)
	}
}


// MARK: - Imports

import XCTest
