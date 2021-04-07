//
//  FeedImageCommentsViewModel.swift
//  EssentialFeediOS
//
//  Created by Oliver Jordy Pérez Escamilla on 06/04/21.
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import EssentialFeed

final class FeedImageCommentsViewModel {
	private let commentsLoader: FeedImageCommentsLoader
	var commentsLoaderTask: FeedImageCommentLoaderTask?
	
	init(commentsLoader: FeedImageCommentsLoader) {
		self.commentsLoader = commentsLoader
	}
	
	private enum State {
		case pending
		case loading
		case canceled
		case loaded([FeedImageComment])
		case failed
	}
	
	private var state = State.pending {
		didSet {
			onChange?(self)
		}
	}
	
	var onChange: ((FeedImageCommentsViewModel) -> Void)?
	
	var isLoading: Bool {
		switch state {
		case .loading:
			return true
		case .failed, .pending, .loaded, .canceled:
			return false
		}
	}
	
	var comments: [FeedImageComment]? {
		switch state {
		case let .loaded(model):
			return model
		case .failed, .pending, .loading, .canceled:
			return nil
		}
	}
	
	func loadComments() {
		state = .loading
		commentsLoaderTask = commentsLoader.load { [weak self] result in
			if let model = try? result.get() {
				self?.state = .loaded(model)
			} else {
				self?.state = .failed
			}
		}
	}
	
	func cancelCommentsLoaderTask() {
		commentsLoaderTask?.cancel()
		state = .canceled
	}
}
