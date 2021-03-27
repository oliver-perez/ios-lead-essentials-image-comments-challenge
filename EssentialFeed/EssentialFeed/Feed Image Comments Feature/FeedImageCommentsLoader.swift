//
//  FeedImageCommentsLoader.swift
//  EssentialFeed
//
//  Created by Oliver Jordy Pérez Escamilla on 17/03/21.
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import Foundation

public protocol FeedImageCommentsLoader {
	typealias Result = Swift.Result<[FeedImageComment], Error>
	
	func load(completion: @escaping (Result) -> Void)
}
