//
//  LoadFeedImageCommentsFromRemoteUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Oliver Jordy Pérez Escamilla on 18/03/21.
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import XCTest
import EssentialFeed

class LoadFeedImageCommentsFromRemoteUseCaseTests: XCTestCase {
	
	func test_init_doesNotRequestDataFromURL() {
		let (_, client) = makeSUT()
		
		XCTAssertTrue(client.requestedURLs.isEmpty)
	}
	
	func test_load_requestsDataFromURL() {
		let url = URL(string: "https://a-given-url.com")!
		let (sut, client) = makeSUT(url: url)
		
		sut.load { _ in }
		
		XCTAssertEqual(client.requestedURLs, [url])
	}
	
	func test_loadTwice_requestsDataFromURLTwice() {
		let url = URL(string: "https://a-given-url.com")!
		let (sut, client) = makeSUT(url: url)
		
		sut.load { _ in }
		sut.load { _ in }
		
		XCTAssertEqual(client.requestedURLs, [url, url])
	}
	
	func test_load_deliversErrorOnClientError() {
		let (sut, client) = makeSUT()
		
		expect(sut, toCompleteWith: .failure(.connectivity), when: {
			client.complete(with: anyNSError())
		})
	}
	
	func test_load_deliversErrorOnNon200HTTPResponse() {
		let (sut, client) = makeSUT()
		
		let samples = [199, 201, 300, 400, 500]
		
		samples.enumerated().forEach { index, code in
			expect(sut, toCompleteWith: .failure(.invalidData), when: {
				client.complete(withStatusCode: code, data: anyData(), at: index)
			})
		}
	}
	
	func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
		let (sut, client) = makeSUT()
		
		expect(sut, toCompleteWith: .failure(.invalidData), when: {
			let invalidJSON = Data("Invalid json".utf8)
			client.complete(withStatusCode: 200, data: invalidJSON)
		})
	}
	
	func test_load_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() {
		let (sut, client) = makeSUT()
		
		expect(sut, toCompleteWith: .success([]), when: {
			let emptyListJSON = Data("{\"items\": []}".utf8)
			client.complete(withStatusCode: 200, data: emptyListJSON)
		})
	}
	
	func test_load_deliversItemsOn200HTTPResponseWithJSONItems() {
		let (sut, client) = makeSUT()
		
		let item1 = FeedImageComment(id: UUID(), message: "", creationDate: "2020-05-20T11:24:59+0000", author: .init(username: ""))
		
		let item1JSON: [String: Any] = [
			"id": item1.id.uuidString,
			"message": item1.message,
			"created_at": item1.creationDate,
			"author": ["username": item1.author.username]
		]
		
		let item2 = FeedImageComment(id: UUID(), message: "", creationDate: "2021-05-20T11:24:59+0000", author: .init(username: ""))
		
		let item2JSON: [String: Any] = [
			"id": item2.id.uuidString,
			"message": item2.message,
			"created_at": item2.creationDate,
			"author": ["username": item2.author.username]
		]
		
		let itemsJSON = [
			"items": [item1JSON, item2JSON]
		]
		
		expect(sut, toCompleteWith: .success([item1, item2]), when: {
			let json = try! JSONSerialization.data(withJSONObject: itemsJSON)
			client.complete(withStatusCode: 200, data: json)
		})
	}
	
	// MARK: - Helpers
	private func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (sut: RemoteFeedImageCommentsLoader, client: HTTPClientSpy) {
		let client = HTTPClientSpy()
		let sut = RemoteFeedImageCommentsLoader(url: url, client: client)
		
		return (sut: sut, client: client)
	}
	
	private func expect(_ sut: RemoteFeedImageCommentsLoader, toCompleteWith result: RemoteFeedImageCommentsLoader.Result, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
		var capturedResults = [RemoteFeedImageCommentsLoader.Result]()
		sut.load { capturedResults.append($0) }
		
		action()
		
		XCTAssertEqual(capturedResults, [result], file: file, line: line)
	}
	
}
