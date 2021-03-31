//
//  FeedImageCommentsViewController.swift
//  EssentialFeediOSTests
//
//  Created by Oliver Jordy Pérez Escamilla on 30/03/21.
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import XCTest

final class FeedImageCommentsViewController {
	init(loader: FeedImageCommentsViewControllerTests.LoaderSpy) {
	}
}

class FeedImageCommentsViewControllerTests: XCTestCase {
	
	func test_init_doesNotLoadFeed() {
		let loader = LoaderSpy()
		_ = FeedImageCommentsViewController(loader: loader)
		
		XCTAssertEqual(loader.loadCount, 0)
	}
	
	final class LoaderSpy {
		private(set) var loadCount = 0
	}
	
}
