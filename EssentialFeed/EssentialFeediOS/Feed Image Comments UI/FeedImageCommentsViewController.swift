//
//  FeedImageCommentsViewController.swift
//  EssentialFeediOS
//
//  Created by Oliver Jordy Pérez Escamilla on 31/03/21.
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import UIKit

protocol FeedImageCommentsControllerDelegate {
	func didRequestFeedRefresh()
}

public final class FeedImageCommentsViewController: UITableViewController, FeedImageCommentsLoadingView {
	
	var delegate: FeedImageCommentsControllerDelegate?
	var cancelCommentsLoaderTask: (() -> Void)?
	
	var tableModel = [FeedImageCommentsCellController]() {
		didSet {
			
			if Thread.isMainThread {
				tableView.reloadData()
			} else {
				DispatchQueue.main.async { [weak self] in
					self?.tableView.reloadData()
				}
			}
			
		}
	}
	
	public override func viewDidLoad() {
		super.viewDidLoad()
		
		refresh()
	}
	
	@IBAction private func refresh() {
		delegate?.didRequestFeedRefresh()
	}
	
	func display(_ viewModel: FeedImageCommentLoadingViewModel) {
		
		guard Thread.isMainThread else { return DispatchQueue.main.async { [weak self] in self?.display(viewModel) } }
		
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
