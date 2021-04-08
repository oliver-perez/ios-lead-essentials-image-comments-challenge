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
	}
	
	private var state = State.pending {
		didSet {
			onChange?(self)
		}
	}
	
	var onChange: ((FeedImageCommentsViewModel) -> Void)?
	var onCommentsLoad: (([FeedImageComment]) -> Void)?
	
	var isLoading: Bool {
		switch state {
		case .loading:
			return true
		case .pending, .canceled:
			return false
		}
	}
	
	func loadComments() {
		state = .loading
		commentsLoaderTask = commentsLoader.load { [weak self] result in
			if let model = try? result.get() {
				self?.onCommentsLoad?(model)
			}
			self?.state = .pending
		}
	}
	
	func cancelCommentsLoaderTask() {
		commentsLoaderTask?.cancel()
		state = .canceled
	}
}
