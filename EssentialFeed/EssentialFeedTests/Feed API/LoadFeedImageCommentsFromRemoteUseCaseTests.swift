//
//  LoadFeedImageCommentsFromRemoteUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Oliver Jordy Pérez Escamilla on 18/03/21.
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import XCTest
import EssentialFeed

final class RemoteFeedImageCommentsLoader {
	
	private let client: HTTPClient
	private let url: URL
	
	init(url: URL, client: HTTPClient) {
		self.client = client
		self.url = url
	}
	
	func load() {
		client.get(from: url, completion: { _ in })
	}
	
}

class LoadFeedImageCommentsFromRemoteUseCaseTests: XCTestCase {

	func test_init_doesNotRequestDataFromURL() {
		let (_, client) = makeSUT()
		
		XCTAssertTrue(client.requestedURLs.isEmpty)
	}
	
	func test_load_requestsDataFromURL() {
		let url = URL(string: "https://a-given-url.com")!
		let (sut, client) = makeSUT(url: url)
		
		sut.load()
		
		XCTAssertEqual(client.requestedURLs, [url])
	}
	
	func test_loadTwice_requestsDataFromURLTwice() {
		let url = URL(string: "https://a-given-url.com")!
		let (sut, client) = makeSUT(url: url)
		
		sut.load()
		sut.load()
		
		XCTAssertEqual(client.requestedURLs, [url, url])
	}
	
	// MARK: - Helpers
	private func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (sut: RemoteFeedImageCommentsLoader, client: HTTPClientSpy) {
		let client = HTTPClientSpy()
		let sut = RemoteFeedImageCommentsLoader(url: url, client: client)
		
		return (sut: sut, client: client)
	}

}
