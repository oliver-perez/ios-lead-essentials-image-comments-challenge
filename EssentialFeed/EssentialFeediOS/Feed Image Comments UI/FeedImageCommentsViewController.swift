//
//  FeedImageCommentsViewController.swift
//  EssentialFeediOS
//
//  Created by Oliver Jordy Pérez Escamilla on 31/03/21.
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import UIKit
import EssentialFeed

public final class FeedImageCommentsViewController: UITableViewController {
	private var refreshController: FeedImageCommentsRefreshViewController?
	private var tableModel = [FeedImageComment]() {
		didSet {
			tableView.reloadData()
		}
	}
	
	public convenience init(commentsLoader: FeedImageCommentsLoader) {
		self.init()
		self.refreshController = .init(commentsLoader: commentsLoader)
	}
	
	public override func viewDidLoad() {
		super.viewDidLoad()
		
		refreshControl = refreshController?.view

		refreshController?.onRefresh = { [weak self] model in
			self?.tableModel = model
		}
		
		refreshController?.refresh()
	}
	
	public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		tableModel.count
	}
	
	public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cellModel = tableModel[indexPath.row]
		let cell = FeedImageCommentCell()
		cell.usernameLabel.text = cellModel.author.username
		cell.dateLabel.text = cellModel.creationDate
		cell.messageLabel.text = cellModel.message
		
		return cell
	}
	
	deinit {
		refreshController?.commentsLoaderTask?.cancel()
	}
	
}
