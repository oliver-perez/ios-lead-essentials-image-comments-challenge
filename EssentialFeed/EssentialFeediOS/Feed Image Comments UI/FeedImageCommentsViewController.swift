//
//  FeedImageCommentsViewController.swift
//  EssentialFeediOS
//
//  Created by Oliver Jordy Pérez Escamilla on 31/03/21.
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import UIKit
import EssentialFeed

public protocol FeedImageCommentsControllerDelegate {
	func didRequestFeedRefresh()
}

public final class FeedImageCommentsViewController: UITableViewController, FeedImageCommentsLoadingView {
	
	public var delegate: FeedImageCommentsControllerDelegate?
	public var cancelCommentsLoaderTask: (() -> Void)?
	
	public var tableModel = [FeedImageCommentsCellController]() {
		didSet {
			tableView.reloadData()
		}
	}
	
	convenience init() {
		self.init()
	}
	
	public override func viewDidLoad() {
		super.viewDidLoad()
		
		refresh()
	}
	
	@IBAction private func refresh() {
		delegate?.didRequestFeedRefresh()
	}
	
	public func display(_ viewModel: FeedImageCommentLoadingViewModel) {
		
		if viewModel.isLoading {
			refreshControl?.beginRefreshing()
		} else {
			refreshControl?.endRefreshing()
		}
	}
	
	public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		tableModel.count
	}
	
	public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		tableModel[indexPath.row].view(in: tableView)
	}
	
	deinit {
		cancelCommentsLoaderTask?()
	}
	
}
