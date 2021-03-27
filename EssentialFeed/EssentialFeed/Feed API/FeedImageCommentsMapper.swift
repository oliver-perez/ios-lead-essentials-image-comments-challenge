//
//  FeedImageCommentsMapper.swift
//  EssentialFeed
//
//  Created by Oliver Jordy Pérez Escamilla on 25/03/21.
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import Foundation

final class FeedImageCommentsMapper {
	
	private struct Root: Decodable {
		let items: [RemoteFeedImageComment]
		
		var feedImageComments: [FeedImageComment] {
			items.map(\.dto)
		}
	}

	private struct RemoteFeedImageComment: Decodable {
		let id: UUID
		let message:	String
		let creationDate: String
		let author: RemoteImageCommentAuthor
		
		var dto: FeedImageComment  {
			.init(id: id,
						message: message,
						creationDate: creationDate,
						author: .init(username: author.username))
		}
		
		init(id: UUID,
				 message: String,
				 creationDate: String,
				 author: RemoteImageCommentAuthor) {
			self.id = id
			self.message = message
			self.creationDate = creationDate
			self.author = author
		}
		
			private enum CodingKeys: String, CodingKey {
				case id
				case message
				case creationDate = "created_at"
				case author
			}
		
	}
	
	private struct RemoteImageCommentAuthor: Decodable {
		public let username: String
		
		public init(username: String) {
			self.username = username
		}
	}
	
	static func map(_ data: Data, _ response: HTTPURLResponse) -> RemoteFeedImageCommentsLoader.Result {
		guard response.isOK,
					let root = try? JSONDecoder().decode(Root.self, from: data) else {
			return .failure(RemoteFeedImageCommentsLoader.Error.invalidData)
		}
		
		return .success(root.feedImageComments)
	}
}
