//
//  RemoteFeedImageCommentsLoader.swift
//  EssentialFeed
//
//  Created by Oliver Jordy Pérez Escamilla on 20/03/21.
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import Foundation

public final class RemoteFeedImageCommentsLoader: FeedImageCommentsLoader {
	
	private let url: URL
	private let client: HTTPClient
	
	public enum Error: Swift.Error {
		case connectivity
		case invalidData
	}
	
	public typealias Result = FeedImageCommentsLoader.Result
	
	public init(url: URL, client: HTTPClient) {
		self.url = url
		self.client = client
	}
	
	public func load(completion: @escaping (Result) -> Void) {
		client.get(from: url) { [weak self] result in
			guard self != nil else { return }

			switch result {
			case let .success((data, response)):
				completion(FeedImageCommentsMapper.map(data, response))
			case .failure:
				completion(.failure(Error.connectivity))			}
		}
	}
	
}
