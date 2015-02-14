//  Copyright (c) 2015 Rob Rix. All rights reserved.

import Assertions
import XCTest

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

	func testAssertingPropertyWithPredicate() {
		let string: String? = ""
		assert(string, { $0.isEmpty })
	}
}
