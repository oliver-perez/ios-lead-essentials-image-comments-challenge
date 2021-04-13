//
//  FeedImageCommentsUIComposer.swift
//  EssentialFeediOS
//
//  Created by Oliver Jordy Pérez Escamilla on 05/04/21.
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import EssentialFeed

public final class FeedImageCommentsUIComposer {
	
	private init() {}
	
	public static func feedCommentsComposedWith(commentsLoader: FeedImageCommentsLoader) -> FeedImageCommentsViewController {
		let presenter = FeedImageCommentsPresenter()
		let presentationAdapter = FeedLoaderPresentationAdapter(presenter: presenter, commentsLoader: commentsLoader)
		let refreshController = FeedImageCommentsRefreshViewController(loadComments: presentationAdapter.loadFeedImageComments, cancelCommentsLoaderTask: presenter.cancelCommentsLoaderTask)
		let feedImageCommentsViewController = FeedImageCommentsViewController(refreshController: refreshController)
		presenter.loadingView = WeakRefVirtualProxy(refreshController)
		let adapter = FeedImageCommentsAdapter(controller: feedImageCommentsViewController)
		presenter.view = adapter
		
		return feedImageCommentsViewController
	}

}

private final class WeakRefVirtualProxy<T: AnyObject> {
	private weak var object: T?
	
	init(_ object: T) {
		self.object = object
	}
}

extension WeakRefVirtualProxy: FeedImageCommentsLoadingView where T: FeedImageCommentsLoadingView {
	func display(_ viewModel: FeedImageCommentLoadingViewModel) {
		object?.display(viewModel)
	}
}

private final class FeedImageCommentsAdapter: FeedImageCommentsView {
	
	private weak var controller: FeedImageCommentsViewController?
	
	init(controller: FeedImageCommentsViewController) {
		self.controller = controller
	}
	
	func display(_ viewModel: FeedImageCommentsViewModel) {
		controller?.tableModel = viewModel
			.comments
			.map { .init(model: $0) }
	}

}

private final class FeedLoaderPresentationAdapter {
	private let presenter: FeedImageCommentsPresenter
	private let commentsLoader: FeedImageCommentsLoader
	
	init(presenter: FeedImageCommentsPresenter, commentsLoader: FeedImageCommentsLoader) {
		self.presenter = presenter
		self.commentsLoader = commentsLoader
	}
	
	func loadFeedImageComments() {
		presenter.didStartLoadingComments()
		
		presenter.commentsLoaderTask = commentsLoader.load { [weak self] result in
			switch result {
			case let .success(comments):
				self?.presenter.didFinishLoadingComments(with: comments)
			case let .failure(error):
				self?.presenter.didFinishLoadingComments(with: error)
			}
		}
	}
	
}
