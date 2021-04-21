//
//  FeedImageCommentsPresenterTests.swift
//  EssentialFeedTests
//
//  Created by Oliver Jordy Pérez Escamilla on 19/04/21.
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import XCTest
import EssentialFeed

struct FeedImageCommentLoadingViewModel {
	let isLoading: Bool
}

protocol FeedImageCommentsLoadingView {
	func display(_ viewModel: FeedImageCommentLoadingViewModel)
}

protocol FeedImageCommentsView: class {
	func display(_ viewModel: FeedImageCommentsViewModel)
}

struct FeedImageCommentsViewModel {
	let comments: [FeedImageComment]
}

final class FeedImageCommentsPresenter {
	
	private let view: FeedImageCommentsView
	private let loadingView: FeedImageCommentsLoadingView

	init(view: FeedImageCommentsView, loadingView: FeedImageCommentsLoadingView) {
		self.view = view
		self.loadingView = loadingView
	}
	
	func didStartLoadingComments() {
		loadingView.display(.init(isLoading: true))
	}
	
	func didFinishLoadingComments(with comments: [FeedImageComment]) {
		view.display(.init(comments: comments))
		loadingView.display(.init(isLoading: false))
	}
	
}

class FeedImageCommentsPresenterTests: XCTestCase {
	
	typealias SUT = FeedImageCommentsPresenter

	func test_init_doesNotSendAnyMessagesToView() {
		let (_, view) = makeSUT()
				
		XCTAssert(view.messages.isEmpty, "Expected no view messages")
	}
	
	func test_didStartLoadingComments_displaysLoadingIndicator() {
		let (sut, view) = makeSUT()
		
		sut.didStartLoadingComments()
		
		XCTAssertEqual(view.messages, [.display(isLoading: true)])
	}
	
	func test_didFinishLoadingComments_displaysComments() {
		let (sut, view) = makeSUT()
		let comments = [FeedImageComment]()
		
		sut.didFinishLoadingComments(with: comments)
		
		XCTAssertEqual(view.messages,
									 [.display(comments: comments),
										.display(isLoading: false)])
	}
	
	// MARK: - Helpers
	
	private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: SUT, view: ViewSpy) {
		let view = ViewSpy()
		let sut = SUT(view: view, loadingView: view)
		
		trackForMemoryLeaks(sut)
		trackForMemoryLeaks(view)
		
		return (sut, view)
	}
	
	private class ViewSpy: FeedImageCommentsLoadingView, FeedImageCommentsView {
		enum Message: Equatable {
			case display(isLoading: Bool)
			case display(comments: [FeedImageComment])
		}
		
		private(set) var messages = [Message]()
		
		func display(_ viewModel: FeedImageCommentLoadingViewModel) {
			messages.append(.display(isLoading: viewModel.isLoading))
		}
		
		func display(_ viewModel: FeedImageCommentsViewModel) {
			messages.append(.display(comments: viewModel.comments))
		}
		
	}

}
