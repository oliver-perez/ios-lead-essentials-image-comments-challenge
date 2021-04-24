//
//  FeedImageCommentsPresenterTests.swift
//  EssentialFeedTests
//
//  Created by Oliver Jordy Pérez Escamilla on 19/04/21.
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import XCTest
import EssentialFeed

class FeedImageCommentsPresenterTests: XCTestCase {
	
	typealias SUT = FeedImageCommentsPresenter
	
	func test_title_isLocalized() {
		XCTAssertEqual(FeedImageCommentsPresenter.title, localized("FEED_IMAGE_COMMENTS_TITLE"))
	}

	func test_init_doesNotSendAnyMessagesToView() {
		let (_, view, _) = makeSUT()
				
		XCTAssert(view.messages.isEmpty, "Expected no view messages")
	}
	
	func test_didStartLoadingComments_displaysLoadingIndicator() {
		let (sut, view, _) = makeSUT()
		
		sut.didStartLoadingComments()
		
		XCTAssertEqual(view.messages, [.display(isLoading: true)])
	}
	
	func test_didFinishLoadingComments_withComments_displaysCommentsAndStopsLoading() {
		let (sut, view, _) = makeSUT()
		let comments = [FeedImageComment]()
		
		sut.didFinishLoadingComments(with: comments)
		
		XCTAssertEqual(view.messages,
									 [.display(comments: comments),
										.display(isLoading: false)])
	}
	
	func test_didFinishLoadingComments_withError_stopsLoading() {
		let (sut, view, _) = makeSUT()
		
		sut.didFinishLoadingComments(with: anyNSError())
		
		XCTAssertEqual(view.messages,
									 [.display(isLoading: false)])
	}
	
	func test_cancelCommentsLoaderTask_cancelsCommentsLoaderTask() {
		let (sut, _, commentsLoaderTask) = makeSUT()
		
		sut.cancelCommentsLoaderTask()
		
		XCTAssertEqual(commentsLoaderTask.messages,
									 [.cancel])
	}
	
	// MARK: - Helpers
	
	private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: SUT, view: ViewSpy, cancelCommentsLoaderTask: FeedImageCommentLoaderTaskSpy) {
		let view = ViewSpy()
		let commentsLoaderTask = FeedImageCommentLoaderTaskSpy()
		let sut = SUT(view: view, loadingView: view)
		sut.commentsLoaderTask = commentsLoaderTask
		
		trackForMemoryLeaks(sut)
		trackForMemoryLeaks(view)
		
		return (sut, view, commentsLoaderTask)
	}
	
	func localized(_ key: String, file: StaticString = #filePath, line: UInt = #line) -> String {
		let table = "FeedImageComments"
		let bundle = Bundle(for: SUT.self)
		let value = bundle.localizedString(forKey: key, value: nil, table: table)
		if value == key {
			XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
		}
		return value
	}
	
	private class FeedImageCommentLoaderTaskSpy: FeedImageCommentLoaderTask {
		
		enum Message {
			case cancel
		}
		
		private(set) var messages = [Message]()
		
		func cancel() {
			messages.append(.cancel)
		}
	}
	
	private class ViewSpy: FeedImageCommentsLoadingView, FeedImageCommentsView {
		enum Message: Hashable {
			
			func hash(into hasher: inout Hasher) {
				hasher.combine(String(describing: self))
			}
			
			case display(isLoading: Bool)
			case display(comments: [FeedImageComment])
		}
		
		private(set) var messages = Set<Message>()
		
		func display(_ viewModel: FeedImageCommentLoadingViewModel) {
			messages.insert(.display(isLoading: viewModel.isLoading))
		}
		
		func display(_ viewModel: FeedImageCommentsViewModel) {
			messages.insert(.display(comments: viewModel.comments))
		}
		
	}

}
