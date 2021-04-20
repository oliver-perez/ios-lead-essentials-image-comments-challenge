//
//  FeedImageCommentsPresenterTests.swift
//  EssentialFeedTests
//
//  Created by Oliver Jordy Pérez Escamilla on 19/04/21.
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import XCTest

final class FeedImageCommentsPresenter {
	init(view: Any) {
	}
}

class FeedImageCommentsPresenterTests: XCTestCase {

	func test_init_doesNotSendAnyMessagesToView() {
		let view = ViewSpy()
		
		_ = FeedImageCommentsPresenter(view: view)
		
		XCTAssert(view.messages.isEmpty, "Expected no view messages")
	}
	
	// MARK: - Helpers
	
	private class ViewSpy {
		let messages = [Any]()
	}

}
