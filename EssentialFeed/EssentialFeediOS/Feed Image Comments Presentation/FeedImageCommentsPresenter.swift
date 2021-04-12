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
	
	private let commentsLoader: FeedImageCommentsLoader
	var commentsLoaderTask: FeedImageCommentLoaderTask?
	
	init(commentsLoader: FeedImageCommentsLoader) {
		self.commentsLoader = commentsLoader
	}

	var view: FeedImageCommentsView?
	var loadingView: FeedImageCommentsLoadingView?

	func loadComments() {
		loadingView?.display(.init(isLoading: true))
		commentsLoaderTask = commentsLoader.load { [weak self] result in
			if let model = try? result.get() {
				self?.view?.display(.init(comments: model))
			}
			self?.loadingView?.display(.init(isLoading: false))
		}
	}
	
	func cancelCommentsLoaderTask() {
		commentsLoaderTask?.cancel()
	}
}
