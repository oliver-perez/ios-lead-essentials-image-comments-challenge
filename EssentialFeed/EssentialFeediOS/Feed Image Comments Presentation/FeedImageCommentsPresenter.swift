//
//  FeedImageCommentsPresenter.swift
//  EssentialFeediOS
//
//  Created by Oliver Jordy Pérez Escamilla on 10/04/21.
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import Foundation
import EssentialFeed

protocol FeedImageCommentsLoadingView: class {
	func display(isLoading: Bool)
}

protocol FeedImageCommentsView: class {
	func display(comments: [FeedImageComment])
}

final class FeedImageCommentsPresenter {
	typealias Observer<T> = (T) -> Void
	
	private let commentsLoader: FeedImageCommentsLoader
	var commentsLoaderTask: FeedImageCommentLoaderTask?
	
	init(commentsLoader: FeedImageCommentsLoader) {
		self.commentsLoader = commentsLoader
	}

	weak var view: FeedImageCommentsView?
	weak var loadingView: FeedImageCommentsLoadingView?

	func loadComments() {
		loadingView?.display(isLoading: true)
		commentsLoaderTask = commentsLoader.load { [weak self] result in
			if let model = try? result.get() {
				self?.view?.display(comments: model)
			}
			self?.loadingView?.display(isLoading: false)
		}
	}
	
	func cancelCommentsLoaderTask() {
		commentsLoaderTask?.cancel()
	}
}
