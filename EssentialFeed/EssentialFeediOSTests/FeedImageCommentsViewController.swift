//
//  FeedImageCommentsViewController.swift
//  EssentialFeediOSTests
//
//  Created by Oliver Jordy Pérez Escamilla on 30/03/21.
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import XCTest
import EssentialFeed

final class FeedImageCommentsViewController: UITableViewController {
	
	private var loader: FeedImageCommentsLoader?
	
	convenience init(loader: FeedImageCommentsLoader) {
		self.init()
		self.loader = loader
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		refreshControl = UIRefreshControl()
		refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
		
		load()
	}
	
	@objc private func load() {
		loader?.load { _ in }
	}
	
}

class FeedImageCommentsViewControllerTests: XCTestCase {
	
	func test_init_doesNotLoadFeedImageComments() {
		let (_, loader) = makeSUT()
		
		XCTAssertEqual(loader.loadCount, 0)
	}
	
	func test_viewDidLoad_loadsFeedImageComments() {
		let (sut, loader) = makeSUT()
		
		sut.loadViewIfNeeded()
		
		XCTAssertEqual(loader.loadCount, 1)
	}
	
	func test_pullToRefresh_loadsFeedImageComments() {
		let (sut, loader) = makeSUT()
		sut.loadViewIfNeeded()
		
		sut
			.refreshControl?
			.allTargets
			.forEach { target in
				sut
					.refreshControl?
					.actions(
						forTarget: target,
						forControlEvent:
							.valueChanged)?
					.forEach {
						(target as NSObject).perform(Selector($0))
					}
			}

		XCTAssertEqual(loader.loadCount, 2)
	}
	
	// MARK: - Helpers
	
	private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: FeedImageCommentsViewController, loader: LoaderSpy) {
		let loader = LoaderSpy()
		let sut = FeedImageCommentsViewController(loader: loader)
				
		trackForMemoryLeaks(sut, file: file, line: line)
		trackForMemoryLeaks(loader, file: file, line: line)
		
		return (sut, loader)
	}
	
	final class LoaderSpy: FeedImageCommentsLoader {
		
		private(set) var loadCount = 0
		
		func load(completion: @escaping (FeedImageCommentsLoader.Result) -> Void) {
			loadCount += 1
		}
		
	}
	
}
