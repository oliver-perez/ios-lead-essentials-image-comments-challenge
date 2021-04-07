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
	var tableModel = [FeedImageCommentsCellController]() {
		didSet {
			tableView.reloadData()
		}
	}
	
	convenience init(refreshController: FeedImageCommentsRefreshViewController) {
		self.init()
		self.refreshController = refreshController
	}
	
	public override func viewDidLoad() {
		super.viewDidLoad()
		
		refreshControl = refreshController?.view
		
		refreshController?.refresh()
	}
	
	public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		tableModel.count
	}
	
	public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		tableModel[indexPath.row].view()
	}
	
	deinit {
		refreshController?.cancelCommentsLoaderTask()
	}
	
}
