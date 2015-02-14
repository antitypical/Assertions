//  Copyright (c) 2014 Rob Rix. All rights reserved.

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
