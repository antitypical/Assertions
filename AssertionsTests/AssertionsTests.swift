//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class AssertionsTests: XCTestCase {
	func testAssertingWithOptionalArrays() {
		let array: [Int]? = [1, 2, 3]
		assert(array, ==, [1, 2, 3])
//		XCTAssertEqual(array, [1, 2, 3]) // => error: value of optional type '[Int]?' not unwrapped; did you mean to use '!' or '?'?
	}

	func testAssertingWithOptionalArraysFailure() {
		let array: [Int]? = [1, 2, 3]
		assertFailure {
			assert(array, ==, [1, 2, 3, 4])
		}
	}


	func testAssertingWithOptionalStrings() {
		let string: String? = "hello"
		assert(string, ==, "hello")
	}

	func testAssertingWithOptionalStringsFailure() {
		let string: String? = "hello"
		assertFailure {
			assert(string, ==, "hello!")
		}
	}


	func testAssertingWithMethods() {
		let set: Set<Int>? = Set([1, 2, 3])
		assert(set, Set.contains, 3)
	}

	func testAssertingWithMethodsFailure() {
		let set: Set<Int>? = Set([1, 2, 3])
		assertFailure {
			assert(set, Set.contains, 4)
		}
	}


	func testAssertingPropertyWithPredicate() {
		let string: String? = ""
		assert(string, { $0.isEmpty })
	}

	func testAssertingPropertyWithPredicateFailure() {
		let string: String? = "1"
		assertFailure {
			assert(string, { $0.isEmpty })
		}
	}


	func testAssertingNilOfEquatableType() {
		let x: Int? = nil
		assert(x, ==, nil)
	}

	func testAssertingNilOfEquatableTypeFailure() {
		let x: Int? = 1
		assertFailure {
			assert(x, ==, nil)
		}
	}

	func testAssertingNonNilOfEquatableType() {
		let x: Int? = 1
		assert(x, !=, nil)
	}

	func testAssertingNonNilOfEquatableTypeFailure() {
		let x: Int? = nil
		assertFailure(x, !=, nil)
	}


	// MARK: Testing assertion failures

	/// Assert that `test` causes an assertion failure.
	func assertFailure<T>(file: String = __FILE__, line: UInt = __LINE__, @noescape _ test: () -> T) -> (message: String, file: String, line: UInt, expected: Bool)? {
		let previous = expectFailure
		expectFailure = true
		test()
		expectFailure = previous
		if let result = failure {
			return result
		} else {
			XCTFail("expected the assertion to fail", file: file, line: line)
			return nil
		}
	}

	/// Workaround for http://www.openradar.me/19996972
	func assertFailure<T>(@autoclosure expression1: () -> T, _ test: (T, T) -> Bool, @autoclosure _ expression2: () -> T, message: String = "", file: String = __FILE__, line: UInt = __LINE__) -> (message: String, file: String, line: UInt, expected: Bool)? {
		return assertFailure {
			assert(expression1(), test, expression2(), message: message, file: file, line: line)
		}
	}

	private var expectFailure: Bool = false
	private var failure: (message: String, file: String, line: UInt, expected: Bool)? = nil

	override func recordFailureWithDescription(message: String, inFile file: String, atLine line: UInt, expected: Bool) {
		if expectFailure {
			failure = (message: message, file: file, line: line, expected: expected)
		} else {
			super.recordFailureWithDescription(message, inFile: file, atLine: line, expected: expected)
		}
	}
}


// MARK: - Imports

import Assertions
import XCTest
