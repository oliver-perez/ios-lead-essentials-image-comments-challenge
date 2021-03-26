//
//  RemoteFeedImageCommentsLoader.swift
//  EssentialFeed
//
//  Created by Oliver Jordy Pérez Escamilla on 20/03/21.
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import Foundation

public final class RemoteFeedImageCommentsLoader {
	
	private let url: URL
	private let client: HTTPClient
	
	public enum Error: Swift.Error {
		case connectivity
		case invalidData
	}
	
	public typealias Result = Swift.Result<[FeedImageComment], Error>
	
	public init(url: URL, client: HTTPClient) {
		self.url = url
		self.client = client
	}
	
	public func load(completion: @escaping (Result) -> Void) {
		client.get(from: url) { result in

			switch result {
			case let .success((data, response)):
				if let items = try? RemoteFeedImageCommentMapper.map(data, response) {
					completion(.success(items))
				} else {
					completion(.failure(.invalidData))
				}
			case .failure:
				completion(.failure(.connectivity))			}
		}
	}
	
}

final private class RemoteFeedImageCommentMapper {
	
	private struct Root: Decodable {
		let items: [RemoteFeedImageComment]
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
	
	static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [FeedImageComment] {
		guard response.isOK else {
			throw RemoteFeedImageCommentsLoader.Error.invalidData
		}
		
		return try JSONDecoder()
			.decode(Root.self, from: data)
			.items
			.map(\.dto)
	}
}
