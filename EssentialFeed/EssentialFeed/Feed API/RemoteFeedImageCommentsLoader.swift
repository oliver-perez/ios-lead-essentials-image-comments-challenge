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
				if response.statusCode == 200, let root = try? JSONDecoder().decode(Root.self, from: data) {
					completion(.success(root.items))
				} else {
					completion(.failure(.invalidData))
				}
			case .failure:
				completion(.failure(.connectivity))			}
		}
	}
	
}

private struct Root: Decodable {
	let items: [FeedImageComment]
}
