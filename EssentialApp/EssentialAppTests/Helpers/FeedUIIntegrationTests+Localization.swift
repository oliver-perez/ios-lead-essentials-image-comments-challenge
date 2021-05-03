//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import Foundation
import XCTest
import EssentialFeed

func localized(in bundle: Bundle, table: String, file: StaticString = #filePath, line: UInt = #line) -> (String) -> String {
	{ key in
		let value = bundle.localizedString(forKey: key, value: nil, table: table)
		if value == key {
			XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
		}
		return value
	}
}
