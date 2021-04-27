//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import UIKit
import CoreData
import Combine
import EssentialFeed

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
	var window: UIWindow?
	
	private lazy var httpClient: HTTPClient = {
		URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
	}()
	
	private lazy var store: FeedStore & FeedImageDataStore = {
		try! CoreDataFeedStore(
			storeURL: NSPersistentContainer
				.defaultDirectoryURL()
				.appendingPathComponent("feed-store.sqlite"))
	}()
	
	private lazy var remoteFeedLoader: RemoteFeedLoader = {
		RemoteFeedLoader(
			url: URL(string: "https://ile-api.essentialdeveloper.com/essential-feed/v1/feed")!,
			client: httpClient)
	}()
	
	private lazy var localFeedLoader: LocalFeedLoader = {
		LocalFeedLoader(store: store, currentDate: Date.init)
	}()
	
	private lazy var remoteImageLoader: RemoteFeedImageDataLoader = {
		RemoteFeedImageDataLoader(client: httpClient)
	}()
	
	private lazy var localImageLoader: LocalFeedImageDataLoader = {
		LocalFeedImageDataLoader(store: store)
	}()
			
	convenience init(httpClient: HTTPClient, store: FeedStore & FeedImageDataStore) {
		self.init()
		self.httpClient = httpClient
		self.store = store
	}
	
	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let scene = (scene as? UIWindowScene) else { return }
		
		window = UIWindow(windowScene: scene)
		configureWindow()
	}
	
	func configureWindow() {
		let navigationController = UINavigationController()
		let feedNavigationAdapter = NavigationAdapter(
			feedImageCommentsCoordinator: FeedImageCommentsCoordinator(
				navigationController: navigationController,
				httpClient: httpClient))
		
		let feedViewController = FeedUIComposer.feedComposedWith(
			feedLoader: makeRemoteFeedLoaderWithLocalFallback,
			imageLoader: makeLocalImageLoaderWithRemoteFallback,
			navigationAdapter: feedNavigationAdapter)
		
		navigationController.pushViewController(feedViewController, animated: false)
		
		window?.rootViewController = navigationController
		
		window?.makeKeyAndVisible()
	}
	
	func sceneWillResignActive(_ scene: UIScene) {
		localFeedLoader.validateCache { _ in }
	}
	
	private func makeRemoteFeedLoaderWithLocalFallback() -> FeedLoader.Publisher {
		return remoteFeedLoader
			.loadPublisher()
			.caching(to: localFeedLoader)
			.fallback(to: localFeedLoader.loadPublisher)
	}
	
	private func makeLocalImageLoaderWithRemoteFallback(url: URL) -> FeedImageDataLoader.Publisher {
		return localImageLoader
			.loadImageDataPublisher(from: url)
			.fallback(to: { [remoteImageLoader, localImageLoader] in
				remoteImageLoader
					.loadImageDataPublisher(from: url)
					.caching(to: localImageLoader, using: url)
			})
	}

}

final class FeedImageCommentsCoordinator {
	let navigationController: UINavigationController
	let httpClient: HTTPClient
	
	init(navigationController: UINavigationController, httpClient: HTTPClient) {
		self.navigationController = navigationController
		self.httpClient = httpClient
	}
	
	func start(with imageId: UUID) {
		let feedImageCommentsViewController = FeedImageCommentsUIComposer
			.feedCommentsComposedWith(commentsLoader: makeFeedImageCommentsLoader(url: makeURL(with: imageId)))
		
		navigationController.pushViewController(feedImageCommentsViewController, animated: true)
	}
	
	private func makeURL(with imageId: UUID) -> URL {
		URL(string: "https://ile-api.essentialdeveloper.com/essential-feed/v1/image/\(imageId)/comments")!
	}
	
	private func makeFeedImageCommentsLoader(url: URL) -> FeedImageCommentsLoader {
		RemoteFeedImageCommentsLoader(url: url, client: httpClient)
	}
}

final class NavigationAdapter: FeedNavigationAdapter {
	
	private let feedImageCommentsCoordinator: FeedImageCommentsCoordinator
	
	init(feedImageCommentsCoordinator: FeedImageCommentsCoordinator) {
		self.feedImageCommentsCoordinator = feedImageCommentsCoordinator
	}
	
	func showComments(for imageId: UUID) {
		feedImageCommentsCoordinator.start(with: imageId)
	}
}
