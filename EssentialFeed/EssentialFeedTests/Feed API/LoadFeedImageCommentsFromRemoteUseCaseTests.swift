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
				let json = makeItemsJSON([])
				client.complete(withStatusCode: code, data: json, at: index)
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
		
		let item1 = makeItem(id: UUID(), message: "", creationDate: "2020-05-20T11:24:59+0000", username: "")
		
		let item2 = makeItem(id: UUID(), message: "", creationDate: "2020-05-20T11:24:59+0000", username: "")
		
		let items = [item1.model, item2.model]
		let itemsJSON = [item1.json, item2.json]
		
		expect(sut, toCompleteWith: .success(items), when: {
			let json = makeItemsJSON(itemsJSON)
			client.complete(withStatusCode: 200, data: json)
		})
	}
	
	// MARK: - Helpers
	private func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (sut: RemoteFeedImageCommentsLoader, client: HTTPClientSpy) {
		let client = HTTPClientSpy()
		let sut = RemoteFeedImageCommentsLoader(url: url, client: client)
		
		return (sut: sut, client: client)
	}
	
	private func makeItem(id: UUID, message: String, creationDate: String, username: String) -> (model: FeedImageComment, json: [String: Any]) {
		let item: FeedImageComment = .init(id: id, message: message, creationDate: creationDate, author: .init(username: username))
		
		let json: [String: Any] = [
			"id": id.uuidString,
			"message": message,
			"created_at": creationDate,
			"author": ["username": username]
		]
		
		return (item, json)
	}
	
	private func makeItemsJSON(_ items: [[String : Any]]) -> Data {
		let json = ["items": items]

		return try! JSONSerialization.data(withJSONObject: json)
	}
	
	private func expect(_ sut: RemoteFeedImageCommentsLoader, toCompleteWith result: RemoteFeedImageCommentsLoader.Result, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
		var capturedResults = [RemoteFeedImageCommentsLoader.Result]()
		sut.load { capturedResults.append($0) }
		
		action()
		
		XCTAssertEqual(capturedResults, [result], file: file, line: line)
	}
	
}
