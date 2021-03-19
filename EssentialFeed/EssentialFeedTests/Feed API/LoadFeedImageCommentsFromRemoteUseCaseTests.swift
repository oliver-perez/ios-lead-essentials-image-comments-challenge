//
//  LoadFeedImageCommentsFromRemoteUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Oliver Jordy Pérez Escamilla on 18/03/21.
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import XCTest

final class RemoteFeedImageCommentsLoader {
	
}

class LoadFeedImageCommentsFromRemoteUseCaseTests: XCTestCase {

	func test_init_doesNotRequestDataFromURL() {
		let (_, client) = makeSUT()
		
		XCTAssertTrue(client.requestedURLs.isEmpty)
	}
	
	// MARK: - Helpers
	private func makeSUT() -> (sut: RemoteFeedImageCommentsLoader, client: HTTPClientSpy) {
		let sut = RemoteFeedImageCommentsLoader()
		let client = HTTPClientSpy()
		
		return (sut: sut, client: client)
	}

}
