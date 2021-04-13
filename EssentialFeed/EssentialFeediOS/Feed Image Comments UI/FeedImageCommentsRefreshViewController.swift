//
//  FeedImageCommentsRefreshViewController.swift
//  EssentialFeediOS
//
//  Created by Oliver Jordy Pérez Escamilla on 04/04/21.
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import UIKit

final class FeedImageCommentsRefreshViewController: NSObject, FeedImageCommentsLoadingView {
	
	private(set) lazy var view = loadView()
	private let loadComments: () -> Void
	
	let cancelCommentsLoaderTask: () -> Void
	
	init(loadComments: @escaping () -> Void, cancelCommentsLoaderTask: @escaping () -> Void) {
		self.loadComments = loadComments
		self.cancelCommentsLoaderTask = cancelCommentsLoaderTask
	}
		
	@objc func refresh() {
		loadComments()
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
