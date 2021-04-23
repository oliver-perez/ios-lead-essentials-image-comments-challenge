//
//  FeedImageCommentsPresenter.swift
//  EssentialFeed
//
//  Created by Oliver Jordy Pérez Escamilla on 22/04/21.
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import Foundation

public final class FeedImageCommentsPresenter {
	
	private let view: FeedImageCommentsView
	private let loadingView: FeedImageCommentsLoadingView
	var commentsLoaderTask: FeedImageCommentLoaderTask?
	
	public static var title: String {
		NSLocalizedString(
			"FEED_IMAGE_COMMENTS_TITLE",
			tableName: "FeedImageComments",
			bundle: Bundle(for: Self.self),
			comment: "Title for the Feed Image Comments view")
	}

	public init(view: FeedImageCommentsView,
			 loadingView: FeedImageCommentsLoadingView,
			 commentsLoaderTask: FeedImageCommentLoaderTask) {
		self.view = view
		self.loadingView = loadingView
		self.commentsLoaderTask = commentsLoaderTask
	}
	
	public func didStartLoadingComments() {
		loadingView.display(.init(isLoading: true))
	}
	
	public func didFinishLoadingComments(with comments: [FeedImageComment]) {
		view.display(.init(comments: comments))
		loadingView.display(.init(isLoading: false))
	}
	
	public func didFinishLoadingComments(with error: Error) {
		loadingView.display(.init(isLoading: false))
	}
	
	public func cancelCommentsLoaderTask() {
		commentsLoaderTask?.cancel()
	}
	
}
