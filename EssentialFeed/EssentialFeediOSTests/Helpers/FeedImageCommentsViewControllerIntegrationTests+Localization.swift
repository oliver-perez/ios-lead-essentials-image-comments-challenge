//
//  FeedImageCommentsViewControllerIntegrationTests+Localization.swift
//  EssentialFeediOSTests
//
//  Created by Oliver Jordy Pérez Escamilla on 16/04/21.
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import Foundation
import XCTest
import EssentialFeed

extension FeedImageCommentsViewControllerIntegrationTests {
	func localized(_ key: String, file: StaticString = #filePath, line: UInt = #line) -> String {
		let table = "FeedImageComments"
		let bundle = Bundle(for: FeedImageCommentsPresenter.self)
		let value = bundle.localizedString(forKey: key, value: nil, table: table)
		if value == key {
			XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
		}
		return value
	}
}
