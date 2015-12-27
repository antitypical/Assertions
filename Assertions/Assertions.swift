//  Copyright (c) 2014 Rob Rix. All rights reserved.

// MARK: - Matching

/// Asserts that a binary function matches two operands.
///
/// This is useful for asserting the equality of collections which only define equality for Equatable element types.
///
///		assert(x, ==, y)
public func assert<T>(@autoclosure expression1: () throws -> T?, _ test: (T, T) -> Bool, @autoclosure _ expression2: () -> T, message: String = "", file: String = __FILE__, line: UInt = __LINE__) -> T? {
	return assertExpected(expression1, test, expression2(), message, file, line)
}

/// Asserts that a binary function matches two operands.
///
/// This is useful for asserting the equality of collections which only define equality for Equatable element types.
///
///		assert(x, ==, y)
public func assert<T, U>(@autoclosure expression1: () throws -> T, _ test: (T, U) -> Bool, @autoclosure _ expression2: () -> U, message: String = "", file: String = __FILE__, line: UInt = __LINE__) -> T? {
	return assertExpected(expression1, test, expression2(), message, file, line)
}

/// Asserts that a curried binary function matches two operands.
///
/// This is useful for asserting that some method applies to the receiver on the left and the operand on the right.
///
///		assert(Set([ 1, 2, 3 ]), Set.contains, 3)
public func assert<T, U>(@autoclosure expression1: () throws -> T?, _ test: T -> U -> Bool, @autoclosure _ expression2: () -> U, message: String = "", file: String = __FILE__, line: UInt = __LINE__) -> T? {
	return assertExpected(expression1, { x, y in test(x)(y) }, expression2(), message, file, line)
}

/// Asserts the truth of a predicate applied to a value.
///
/// This is useful for asserting that a value has some property or other.
///
///		assert("", { $0.isEmpty })
public func assert<T>(@autoclosure expression: () throws -> T?, message: String = "", file: String = __FILE__, line: UInt = __LINE__, _ test: T -> Bool) -> T? {
	return assertPredicate(expression, test, message, file, line)
}


// MARK: - Equality

/// Asserts the equality of two Equatable values.
///
/// Returns the value, if equal and non-nil.
public func assertEqual<T: Equatable>(@autoclosure expression1: () throws -> T?, @autoclosure _ expression2: () -> T?, _ message: String = "", _ file: String = __FILE__, _ line: UInt = __LINE__) -> T? {
	return assertExpected(expression1, { $0 == $1 }, expression2(), message, file, line)
}


/// Asserts the equality of two arrays of Equatable values.
///
/// Returns the array, if equal and non-nil.
public func assertEqual<T: Equatable>(@autoclosure expression1: () throws -> [T]?, @autoclosure _ expression2: () -> [T]?, _ message: String = "", _ file: String = __FILE__, _ line: UInt = __LINE__) -> [T]? {
	return assertExpected(expression1, ==, expression2(), message, file, line)
}


/// Asserts the equality of two dictionaries of Equatable values.
///
/// Returns the dictionary, if equal and non-nil.
public func assertEqual<T: Hashable, U: Equatable>(@autoclosure expression1: () throws -> [T: U]?, @autoclosure _ expression2: () -> [T: U]?, _ message: String = "", _ file: String = __FILE__, _ line: UInt = __LINE__) -> [T: U]? {
	return assertExpected(expression1, ==, expression2(), message, file, line)
}


// MARK: - Nil/non-nil

/// Asserts that a value is nil.
public func assertNil<T>(@autoclosure expression: () -> T?, _ message: String = "", file: String = __FILE__, line: UInt = __LINE__) -> Bool {
	return expression().map { failure("\(String(reflecting: $0)) is not nil. " + message, file: file, line: line) } ?? true
}

/// Asserts that a value is not nil.
public func assertNotNil<T>(@autoclosure expression: () throws -> T?, _ message: String = "", file: String = __FILE__, line: UInt = __LINE__) -> T? {
	return assertPredicate(expression, { $0 != nil }, "is nil. " + message, file, line)
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

private func assertPredicate<T>(@noescape actual: () throws -> T?, _ predicate: T -> Bool, _ message: String, _ file: String, _ line: UInt) -> T? {
	do {
		let actual = try actual()
		switch actual {
		case let .Some(x) where predicate(x):
			return actual
		default:
			return failure(message, file: file, line: line)
		}
	} catch {
		return failure("caught error: '\(error)' \(message)", file: file, line: line)
	}
}

private func assertExpected<T, U>(@noescape actual: () throws -> T?, _ match: (T, U) -> Bool, _ expected: U?, _ message: String, _ file: String, _ line: UInt) -> T? {
	do {
		let actual = try actual()
		switch (actual, expected) {
		case (.None, .None):
			return actual
		case let (.Some(x), .Some(y)) where match(x, y):
			return actual
		case let (.Some(x), .Some(y)):
			return failure("\(String(reflecting: x)) did not match \(String(reflecting: y)). " + message, file: file, line: line)
		case let (.Some(x), .None):
			return failure("\(String(reflecting: x)) did not match nil. " + message, file: file, line: line)
		case let (.None, .Some(y)):
			return failure("nil did not match \(String(reflecting: y)). " + message, file: file, line: line)
		}
	} catch {
		return failure("caught error: '\(error)' \(message)", file: file, line: line)
	}
}


// MARK: - Imports

import XCTest
