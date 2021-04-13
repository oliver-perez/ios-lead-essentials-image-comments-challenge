//
//  FeedImageCommentsRefreshViewController.swift
//  EssentialFeediOS
//
//  Created by Oliver Jordy Pérez Escamilla on 04/04/21.
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import UIKit

protocol FeedImageCommentsRefreshViewControllerDelegate {
	func didRequestFeedRefresh()
}

final class FeedImageCommentsRefreshViewController: NSObject, FeedImageCommentsLoadingView {
	
	private(set) lazy var view = loadView()
	private let delegate: FeedImageCommentsRefreshViewControllerDelegate
	
	var cancelCommentsLoaderTask: () -> Void
	
	init(delegate: FeedImageCommentsRefreshViewControllerDelegate, cancelCommentsLoaderTask: @escaping () -> Void) {
		self.delegate = delegate
		self.cancelCommentsLoaderTask = cancelCommentsLoaderTask
	}
		
	@objc func refresh() {
		delegate.didRequestFeedRefresh()
	}
	
	private func loadView() -> UIRefreshControl {
		let view = UIRefreshControl()
		view.addTarget(self, action: #selector(refresh), for: .valueChanged)
		return view
	}
	
	func display(_ viewModel: FeedImageCommentLoadingViewModel) {
		if viewModel.isLoading {
			view.beginRefreshing()
		} else {
			view.endRefreshing()
		}
	}

}
