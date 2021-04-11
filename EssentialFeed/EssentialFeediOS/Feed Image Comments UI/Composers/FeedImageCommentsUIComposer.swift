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
		let presenter = FeedImageCommentsPresenter(commentsLoader: commentsLoader)
		let refreshController = FeedImageCommentsRefreshViewController(presenter: presenter)
		let feedImageCommentsViewController = FeedImageCommentsViewController(refreshController: refreshController)
		presenter.loadingView = refreshController
		let adapter = FeedImageCommentsAdapter(controller: feedImageCommentsViewController)
		presenter.view = adapter
		
		return feedImageCommentsViewController
	}

}

private final class FeedImageCommentsAdapter: FeedImageCommentsView {
	
	private weak var controller: FeedImageCommentsViewController?
	
	init(controller: FeedImageCommentsViewController) {
		self.controller = controller
	}
	
	func display(comments model: [FeedImageComment]) {
			controller?.tableModel = model.map { FeedImageCommentsCellController(model: $0) }
	}

}
