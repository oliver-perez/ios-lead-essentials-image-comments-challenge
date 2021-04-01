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
		refreshControl?.beginRefreshing()
		load()
	}
	
	@objc private func load() {
		loader?.load { [weak self] _ in
			self?.refreshControl?.endRefreshing()
		}
	}
	
}

class FeedImageCommentsViewControllerTests: XCTestCase {
	
	func test_init_doesNotLoadFeedImageComments() {
		let (_, loader) = makeSUT()
		
		XCTAssertEqual(loader.loadCallCount, 0)
	}
	
	func test_viewDidLoad_loadsFeedImageComments() {
		let (sut, loader) = makeSUT()
		
		sut.loadViewIfNeeded()
		
		XCTAssertEqual(loader.loadCallCount, 1)
	}
	
	func test_pullToRefresh_loadsFeedImageComments() {
		let (sut, loader) = makeSUT()
		sut.loadViewIfNeeded()
		
		sut.refreshControl?.simulatePullToRefresh()
		XCTAssertEqual(loader.loadCallCount, 2)
		
		sut.refreshControl?.simulatePullToRefresh()
		XCTAssertEqual(loader.loadCallCount, 3)
	}
	
	func test_viewDidLoad_showsLoadingIndicator() {
		let (sut, _) = makeSUT()

		sut.loadViewIfNeeded()
		
		XCTAssertEqual(sut.refreshControl?.isRefreshing, true)
	}
	
	func test_viewDidLoad_hidesLoadingIndicatorOnLoaderCompletion() {
		let (sut, loader) = makeSUT()
		
		sut.loadViewIfNeeded()
		loader.completeFeedImageCommentsLoading()
		
		XCTAssertEqual(sut.refreshControl?.isRefreshing, false)
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
		
		private(set) var completions = [(FeedImageCommentsLoader.Result) -> Void]()
		
		var loadCallCount: Int {
			completions.count
		}
		
		func load(completion: @escaping (FeedImageCommentsLoader.Result) -> Void) {
			completions.append(completion)
		}
		
		func completeFeedImageCommentsLoading() {
			completions[0](.success([]))
		}
		
	}
	
}
