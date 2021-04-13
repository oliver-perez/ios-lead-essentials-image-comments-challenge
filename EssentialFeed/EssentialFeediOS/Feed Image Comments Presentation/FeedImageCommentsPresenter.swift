//
//  FeedImageCommentsPresenter.swift
//  EssentialFeediOS
//
//  Created by Oliver Jordy Pérez Escamilla on 10/04/21.
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import Foundation
import EssentialFeed

struct FeedImageCommentLoadingViewModel {
	let isLoading: Bool
}

protocol FeedImageCommentsLoadingView {
	func display(_ viewModel: FeedImageCommentLoadingViewModel)
}

struct FeedImageCommentsViewModel {
	let comments: [FeedImageComment]
}

protocol FeedImageCommentsView: class {
	func display(_ viewModel: FeedImageCommentsViewModel)
}

final class FeedImageCommentsPresenter {
	typealias Observer<T> = (T) -> Void

	var view: FeedImageCommentsView?
	var loadingView: FeedImageCommentsLoadingView?
	var commentsLoaderTask: FeedImageCommentLoaderTask?
	
	func didStartLoadingComments() {
		loadingView?.display(.init(isLoading: true))
	}
	
	func didFinishLoadingComments(with comments: [FeedImageComment]) {
		view?.display(.init(comments: comments))
		loadingView?.display(.init(isLoading: false))
	}

	func didFinishLoadingComments(with error: Error) {
		loadingView?.display(.init(isLoading: false))
	}
	
	func cancelCommentsLoaderTask() {
		commentsLoaderTask?.cancel()
	}
	
}
