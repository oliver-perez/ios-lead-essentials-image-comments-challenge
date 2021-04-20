//
//  FeedImageCommentsPresenterTests.swift
//  EssentialFeedTests
//
//  Created by Oliver Jordy Pérez Escamilla on 19/04/21.
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import XCTest

struct FeedImageCommentLoadingViewModel {
	let isLoading: Bool
}

protocol FeedImageCommentsLoadingView {
	func display(_ viewModel: FeedImageCommentLoadingViewModel)
}

final class FeedImageCommentsPresenter {
	private let loadingView: FeedImageCommentsLoadingView

	init(loadingView: FeedImageCommentsLoadingView) {
		self.loadingView = loadingView
	}
	
	func didStartLoadingComments() {
		loadingView.display(.init(isLoading: true))
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
	
	// MARK: - Helpers
	
	private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: SUT, view: ViewSpy) {
		let view = ViewSpy()
		let sut = SUT(loadingView: view)
		
		trackForMemoryLeaks(sut)
		trackForMemoryLeaks(view)
		
		return (sut, view)
	}
	
	private class ViewSpy: FeedImageCommentsLoadingView {
		enum Message: Equatable {
			case display(isLoading: Bool)
		}
		
		private(set) var messages = [Message]()
		
		func display(_ viewModel: FeedImageCommentLoadingViewModel) {
			messages.append(.display(isLoading: viewModel.isLoading))
		}
		
	}

}
