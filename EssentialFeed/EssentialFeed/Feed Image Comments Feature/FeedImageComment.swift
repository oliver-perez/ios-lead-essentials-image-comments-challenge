//
//  FeedImageComment.swift
//  EssentialFeed
//
//  Created by Oliver Jordy Pérez Escamilla on 17/03/21.
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import Foundation

struct FeedImageComment {
	let id: UUID
	let message:	String
	let creationDate:	Date
	let author:	ImageCommentAuthor
}

struct ImageCommentAuthor {
	let username: String
}
