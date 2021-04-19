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
		let presentationAdapter = FeedLoaderPresentationAdapter(commentsLoader: MainQueueDispatchDecorator(decoratee: commentsLoader))
				
		let feedImageCommentsViewController = FeedImageCommentsViewController.makeWith(
			delegate: presentationAdapter,
			title: FeedImageCommentsPresenter.title,
			cancelCommentsLoaderTask: presentationAdapter.cancelCommentsLoaderTask)
		
		let presenter = FeedImageCommentsPresenter(view: FeedImageCommentsAdapter(controller: feedImageCommentsViewController), loadingView:  WeakRefVirtualProxy(feedImageCommentsViewController))
		
		presentationAdapter.presenter = presenter
				
		return feedImageCommentsViewController
	}

}

private final class MainQueueDispatchDecorator<T> {
	private let decoratee: T
	
	init(decoratee: T) {
		self.decoratee = decoratee
	}
	
	func dispatch(completion: @escaping () -> Void) {
		guard Thread.isMainThread else {
			return DispatchQueue.main.async {
				completion()
			}
		}
		completion()
	}
	
}

extension MainQueueDispatchDecorator: FeedImageCommentsLoader where T == FeedImageCommentsLoader {
	func load(completion: @escaping (FeedImageCommentsLoader.Result) -> Void) -> FeedImageCommentLoaderTask {
		decoratee.load { [weak self] result in
			self?.dispatch {
				completion(result)
			}
		}
	}
}

private extension FeedImageCommentsViewController {
	static func makeWith(delegate: FeedImageCommentsControllerDelegate, title: String, cancelCommentsLoaderTask: (() -> Void)?) -> Self {
		let bundle = Bundle(for: Self.self)
		let storyboard = UIStoryboard(name: "FeedImageComments", bundle: bundle)
		let feedController = storyboard.instantiateInitialViewController() as! Self
		feedController.delegate = delegate
		feedController.title = title
		feedController.cancelCommentsLoaderTask = cancelCommentsLoaderTask
		return feedController
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

private final class FeedLoaderPresentationAdapter: FeedImageCommentsControllerDelegate {
	
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
