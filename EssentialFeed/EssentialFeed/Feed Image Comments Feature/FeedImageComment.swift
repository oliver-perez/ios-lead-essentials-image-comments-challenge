//
//  FeedImageComment.swift
//  EssentialFeed
//
//  Created by Oliver Jordy Pérez Escamilla on 17/03/21.
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import Foundation

public struct FeedImageComment: Equatable {
	public let id: UUID
	public let message:	String
	public let creationDate: String
	public let author: ImageCommentAuthor
	
	public init(id: UUID,
							message: String,
							creationDate: String,
							author: ImageCommentAuthor) {
		self.id = id
		self.message = message
		self.creationDate = creationDate
		self.author = author
	}
	
}

public struct ImageCommentAuthor: Equatable, Decodable {
	public let username: String
	
	public init(username: String) {
		self.username = username
	}
}
