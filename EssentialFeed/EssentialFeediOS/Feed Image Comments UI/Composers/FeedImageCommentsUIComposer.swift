//
//  FeedImageCommentsUIComposer.swift
//  EssentialFeediOS
//
//  Created by Oliver Jordy Pérez Escamilla on 05/04/21.
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import UIKit
import EssentialFeed

public final class FeedImageCommentsUIComposer {
	
	private init() {}
	
	public static func feedCommentsComposedWith(commentsLoader: FeedImageCommentsLoader) -> FeedImageCommentsViewController {
		let presentationAdapter = FeedLoaderPresentationAdapter(commentsLoader: commentsLoader)
		
		let bundle = Bundle(for: FeedImageCommentsViewController.self)
		let storyboard = UIStoryboard(name: "FeedImageComments", bundle: bundle)
		
		let feedImageCommentsViewController = storyboard.instantiateInitialViewController() as! FeedImageCommentsViewController
		
		let refreshController = feedImageCommentsViewController.refreshController
		refreshController?.delegate = presentationAdapter
		refreshController?.cancelCommentsLoaderTask = presentationAdapter.cancelCommentsLoaderTask
		
		let presenter = FeedImageCommentsPresenter(view: FeedImageCommentsAdapter(controller: feedImageCommentsViewController), loadingView:  WeakRefVirtualProxy(refreshController))
		
		presentationAdapter.presenter = presenter
				
		return feedImageCommentsViewController
	}

}

private final class WeakRefVirtualProxy<T: AnyObject> {
	private weak var object: T?
	
	init(_ object: T?) {
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

private final class FeedLoaderPresentationAdapter: FeedImageCommentsRefreshViewControllerDelegate {
	
	var presenter: FeedImageCommentsPresenter?
	let commentsLoader: FeedImageCommentsLoader
	
	init(commentsLoader: FeedImageCommentsLoader) {
		self.commentsLoader = commentsLoader
	}
	
	func didRequestFeedRefresh() {
		presenter?.didStartLoadingComments()
		
		presenter?.commentsLoaderTask = commentsLoader.load { [weak self] result in
			switch result {
			case let .success(comments):
				self?.presenter?.didFinishLoadingComments(with: comments)
			case let .failure(error):
				self?.presenter?.didFinishLoadingComments(with: error)
			}
		}
	}
	
	func cancelCommentsLoaderTask() {
		presenter?.cancelCommentsLoaderTask()
	}
	
}
