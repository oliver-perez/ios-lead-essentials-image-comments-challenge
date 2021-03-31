//
//  FeedImageCommentsViewController.swift
//  EssentialFeediOSTests
//
//  Created by Oliver Jordy Pérez Escamilla on 30/03/21.
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import XCTest

final class FeedImageCommentsViewController: UIViewController {
	
	private var loader: FeedImageCommentsViewControllerTests.LoaderSpy?
	
	convenience init(loader: FeedImageCommentsViewControllerTests.LoaderSpy) {
		self.init()
		self.loader = loader
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		loader?.load()
	}
}

class FeedImageCommentsViewControllerTests: XCTestCase {
	
	func test_init_doesNotLoadFeedImageComments() {
		let loader = LoaderSpy()
		_ = FeedImageCommentsViewController(loader: loader)
		
		XCTAssertEqual(loader.loadCount, 0)
	}
	
	func test_viewDidLoad_loadsFeedImageComments() {
		let loader = LoaderSpy()
		let sut = FeedImageCommentsViewController(loader: loader)
		
		sut.loadViewIfNeeded()
		
		XCTAssertEqual(loader.loadCount, 1)
	}
	
	final class LoaderSpy {
		private(set) var loadCount = 0
		
		func load() {
			loadCount += 1
		}
	}
	
}
