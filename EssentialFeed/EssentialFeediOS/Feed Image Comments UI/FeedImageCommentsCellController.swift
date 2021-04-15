//
//  FeedImageCommentsCellController.swift
//  EssentialFeediOS
//
//  Created by Oliver Jordy Pérez Escamilla on 05/04/21.
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import EssentialFeed
import UIKit

final class FeedImageCommentsCellController {
	
	private let model: FeedImageComment
	var cell: FeedImageCommentCell?
	
	init(model: FeedImageComment) {
		self.model = model
	}
	
	func view(in tableView: UITableView) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "FeedImageCommentCell") as! FeedImageCommentCell
		cell.usernameLabel.text = model.author.username
		cell.dateLabel.text = model.creationDate
		cell.messageLabel.text = model.message
		
		self.cell = cell
		return cell
	}
}
