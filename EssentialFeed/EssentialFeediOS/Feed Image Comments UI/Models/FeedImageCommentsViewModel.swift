//
//  FeedImageCommentsViewModel.swift
//  EssentialFeediOS
//
//  Created by Oliver Jordy Pérez Escamilla on 06/04/21.
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import EssentialFeed

final class FeedImageCommentsViewModel {
	typealias Observer<T> = (T) -> Void
	
	private let commentsLoader: FeedImageCommentsLoader
	var commentsLoaderTask: FeedImageCommentLoaderTask?
	
	init(commentsLoader: FeedImageCommentsLoader) {
		self.commentsLoader = commentsLoader
	}

	var onLoadingStateChange: Observer<Bool>?
	var onCommentsLoad: Observer<[FeedImageComment]>?
	var onCancelTask: Observer<Void>?

	func loadComments() {
		onLoadingStateChange?(true)
		commentsLoaderTask = commentsLoader.load { [weak self] result in
			if let model = try? result.get() {
				self?.onCommentsLoad?(model)
			}
			self?.onLoadingStateChange?(false)

		}
	}
	
	func cancelCommentsLoaderTask() {
		commentsLoaderTask?.cancel()
		onCancelTask?(())
	}
}
