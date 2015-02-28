//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class AssertionsTests: XCTestCase {
	func testAssertingWithOptionalArrays() {
		let array: [Int]? = [1, 2, 3]
		assert(array, ==, [1, 2, 3])
//		XCTAssertEqual(array, [1, 2, 3]) // => error: value of optional type '[Int]?' not unwrapped; did you mean to use '!' or '?'?
	}

	func testAssertingWithOptionalStrings() {
		let string: String? = "hello"
		assert(string, ==, "hello")
//		XCTAssertEqual(string, "hello") // => error: cannot find an overload for 'XCTAssertEqual' that accepts an argument list of type '(String?, String)'
	}

	func testAssertingWithMethods() {
		let set: Set<Int>? = Set([1, 2, 3])
		assert(set, Set.contains, 3)
	}

	func testAssertingWithMethodsFailure() {
		let set: Set<Int>? = Set([1, 2, 3])
		let observation = assertFailure {
			assert(set, Set.contains, 4)
		}
	}

	func testAssertingPropertyWithPredicate() {
		let string: String? = ""
		assert(string, { $0.isEmpty })
	}

	func testAssertingNilOfEquatableType() {
		let x: Int? = nil
		assert(x, ==, nil)
	}

	func testAssertingNonNilOfEquatableType() {
		let x: Int? = 1
		assert(x, !=, nil)
	}



	// MARK: Testing assertion failures

	/// Assert that `test` causes an assertion failure.
	func assertFailure(file: String = __FILE__, line: UInt = __LINE__, test: () -> ()) -> (message: String, file: String, line: UInt, expected: Bool)? {
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

	private var expectFailure: Bool = false
	private var failure: (message: String, file: String, line: UInt, expected: Bool)? = nil

	override func recordFailureWithDescription(message: String!, inFile file: String!, atLine line: UInt, expected: Bool) {
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
