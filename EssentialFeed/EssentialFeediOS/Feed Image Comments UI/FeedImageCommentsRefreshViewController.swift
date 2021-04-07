//
//  FeedImageCommentsRefreshViewController.swift
//  EssentialFeediOS
//
//  Created by Oliver Jordy Pérez Escamilla on 04/04/21.
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import UIKit
import EssentialFeed

final class FeedImageCommentsRefreshViewController: NSObject {
	private(set) lazy var view: UIRefreshControl = binded(UIRefreshControl())
	
	private let viewModel: FeedImageCommentsViewModel
	
	init(commentsLoader: FeedImageCommentsLoader) {
		self.viewModel = FeedImageCommentsViewModel(commentsLoader: commentsLoader)
	}
	
	var onRefresh: (([FeedImageComment]) -> Void)?
	
	@objc func refresh() {
		viewModel.loadComments()
	}
	
	private func binded(_ view: UIRefreshControl) -> UIRefreshControl {
		viewModel.onChange = { [weak self] viewModel in
			if viewModel.isLoading {
				self?.view.beginRefreshing()
			} else {
				self?.view.endRefreshing()
			}
			
			if let comments = viewModel.comments {
				self?.onRefresh?(comments)
			}
		}
		view.addTarget(self, action: #selector(refresh), for: .valueChanged)
		return view
	}
	
	func cancelCommentsLoaderTask() {
		viewModel.cancelCommentsLoaderTask()
	}

}
