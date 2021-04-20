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
	
	typealias SUT = FeedImageCommentsPresenter

	func test_init_doesNotSendAnyMessagesToView() {
		let (_, view) = makeSUT()
				
		XCTAssert(view.messages.isEmpty, "Expected no view messages")
	}
	
	// MARK: - Helpers
	
	private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: SUT, view: ViewSpy) {
		let view = ViewSpy()
		let sut = SUT(view: view)
		
		trackForMemoryLeaks(sut)
		trackForMemoryLeaks(view)
		
		return (sut, view)
	}
	
	private class ViewSpy {
		let messages = [Any]()
	}

}
