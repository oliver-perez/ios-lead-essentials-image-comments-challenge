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
	
	init(model: FeedImageComment) {
		self.model = model
	}
	
	func view() -> UITableViewCell {
		let cell = FeedImageCommentCell()
		cell.usernameLabel.text = model.author.username
		cell.dateLabel.text = model.creationDate
		cell.messageLabel.text = model.message
		
		return cell
	}
}
