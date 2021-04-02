//
//  FeedImageCommentsViewController.swift
//  EssentialFeediOSTests
//
//  Created by Oliver Jordy Pérez Escamilla on 30/03/21.
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import XCTest
import EssentialFeediOS
import EssentialFeed

class FeedImageCommentsViewControllerTests: XCTestCase {
	
	func test_loadFeedImageCommentsActions_requestCommentsFromLoader() {
		let (sut, loader) = makeSUT()
		
		XCTAssertEqual(loader.loadCallCount, 0, "Expected no loading requests before view is loaded")
		
		sut.loadViewIfNeeded()
		XCTAssertEqual(loader.loadCallCount, 1, "Expected a loading request once view is loaded")

		sut.simulateUserInitiatedCommentsReload()
		XCTAssertEqual(loader.loadCallCount, 2, "Expected another loading request once user initiates load")
		
		sut.simulateUserInitiatedCommentsReload()
		XCTAssertEqual(loader.loadCallCount, 3, "Expected a third loading request once user initiates another load")
	}
	
	func test_loadingIndicator_isVisibleWhileLoadingComments() {
		let (sut, loader) = makeSUT()

		sut.loadViewIfNeeded()
		XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once view is loaded")
		
		loader.completeFeedImageCommentsLoading(at: 0)
		XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once loading is completed")

		sut.simulateUserInitiatedCommentsReload()
		XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once user initiates a reload")

		loader.completeFeedImageCommentsLoading(at: 1)
		XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once user initiated reloading is completed")
	}
	
	func test_loadCommentsCompletion_showsSuccessfullyLoadedComments() {
		let comment0 = makeFeedImageComment(message: "A message", creationDate: "A creation date", username: "A username")
		let comment1 = makeFeedImageComment(message: "A message", creationDate: "A creation date", username: "A username")
		let comment2 = makeFeedImageComment(message: "A message", creationDate: "A creation date", username: "A username")
		let comment3 = makeFeedImageComment(message: "A message", creationDate: "A creation date", username: "A username")

		let (sut, loader) = makeSUT()

		sut.loadViewIfNeeded()
		XCTAssertEqual(sut.numberOfRenderedComments(), 0)

		loader.completeFeedImageCommentsLoading(with: [comment0],at: 0)
		XCTAssertEqual(sut.numberOfRenderedComments(), 1)
		
		let view = sut.feedImageComment(at: 0) as? FeedImageCommentCell
		XCTAssertNotNil(view)
		XCTAssertEqual(view?.username, comment0.author.username)
		XCTAssertEqual(view?.date, comment0.creationDate)
		XCTAssertEqual(view?.message, comment0.message)
		
		sut.simulateUserInitiatedCommentsReload()
		loader.completeFeedImageCommentsLoading(with:  [comment0, comment1, comment2, comment3], at: 1)
		XCTAssertEqual(sut.numberOfRenderedComments(), 4)
	}
	
	// MARK: - Helpers
	
	private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: FeedImageCommentsViewController, loader: LoaderSpy) {
		let loader = LoaderSpy()
		let sut = FeedImageCommentsViewController(loader: loader)
				
		trackForMemoryLeaks(sut, file: file, line: line)
		trackForMemoryLeaks(loader, file: file, line: line)
		
		return (sut, loader)
	}
	
	private func makeFeedImageComment(message: String, creationDate: String, username: String) -> FeedImageComment {
		.init(id: .init(),
					message: message,
					creationDate: creationDate,
					author: .init(username: username))
	}
	
	final class LoaderSpy: FeedImageCommentsLoader {
		
		private(set) var completions = [(FeedImageCommentsLoader.Result) -> Void]()
		
		var loadCallCount: Int {
			completions.count
		}
		
		func load(completion: @escaping (FeedImageCommentsLoader.Result) -> Void) {
			completions.append(completion)
		}
		
		func completeFeedImageCommentsLoading(with comments: [FeedImageComment] = [], at index: Int) {
			completions[index](.success(comments))
		}
		
	}
	
}

private extension FeedImageCommentsViewController {
	func simulateUserInitiatedCommentsReload() {
		refreshControl?.simulatePullToRefresh()
	}
	
	var isShowingLoadingIndicator: Bool {
		refreshControl?.isRefreshing == true
	}
	
	func numberOfRenderedComments() -> Int {
		tableView.numberOfRows(inSection: .zero)
	}
	
	func feedImageComment(at row: Int) -> UITableViewCell? {
		let ds = tableView.dataSource
		let index = IndexPath(row: row, section: .zero)
		
		return ds?.tableView(tableView, cellForRowAt: index)
	}
}

private extension FeedImageCommentCell {
	var username: String? {
		usernameLabel.text
	}
	var date: String? {
		dateLabel.text
	}
	var message: String? {
		messageLabel.text
	}
}
