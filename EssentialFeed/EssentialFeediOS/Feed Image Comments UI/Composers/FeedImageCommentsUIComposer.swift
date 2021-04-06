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
		let refreshController = FeedImageCommentsRefreshViewController(commentsLoader: commentsLoader)
		let feedImageCommentsViewController = FeedImageCommentsViewController(refreshController: refreshController)
		refreshController.onRefresh = adaptFeedImageCommentsToFeedImageCommentsCellControllers(forwardingTo: feedImageCommentsViewController)
		
		return feedImageCommentsViewController
	}
	
	private static func adaptFeedImageCommentsToFeedImageCommentsCellControllers(forwardingTo controller: FeedImageCommentsViewController) -> ([FeedImageComment]) -> Void {
		{ [weak controller] model in
			controller?.tableModel = model.map { FeedImageCommentsCellController(model: $0) }
		}
	}

}
