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
	
	private var loader: FeedImageCommentsLoader?
	private var tableModel = [FeedImageComment]()
	
	public convenience init(loader: FeedImageCommentsLoader) {
		self.init()
		self.loader = loader
	}
	
	public override func viewDidLoad() {
		super.viewDidLoad()
		
		refreshControl = UIRefreshControl()
		refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
		load()
	}
	
	@objc private func load() {
		refreshControl?.beginRefreshing()
		
		loader?.load { [weak self] result in
			if let model = try? result.get() {
				self?.tableModel = model
				self?.tableView.reloadData()
			}
			self?.refreshControl?.endRefreshing()
		}
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
	
}
