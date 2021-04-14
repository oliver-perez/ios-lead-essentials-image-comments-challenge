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
	
	@IBOutlet private(set) var view: UIRefreshControl?
	
	var delegate: FeedImageCommentsRefreshViewControllerDelegate?
	var cancelCommentsLoaderTask: (() -> Void)?
	
	@IBAction func refresh() {
		delegate?.didRequestFeedRefresh()
	}
	
	func display(_ viewModel: FeedImageCommentLoadingViewModel) {
		if viewModel.isLoading {
			view?.beginRefreshing()
		} else {
			view?.endRefreshing()
		}
	}

}
