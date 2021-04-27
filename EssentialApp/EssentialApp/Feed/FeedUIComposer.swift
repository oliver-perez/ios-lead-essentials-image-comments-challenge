//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import UIKit
import Combine
import EssentialFeed
import EssentialFeediOS

class BannerViewController: UIViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .yellow
	}
}

public final class FeedUIComposer {
	private init() {}
	
	public static func feedComposedWith(
		feedLoader: @escaping () -> FeedLoader.Publisher,
		imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher,
		navigationAdapter: FeedNavigationAdapter
	) -> FeedViewController {
		let presentationAdapter = FeedLoaderPresentationAdapter(feedLoader: feedLoader)
		
		let feedController = makeFeedViewController(
			delegate: presentationAdapter,
			title: FeedPresenter.title)
		
		presentationAdapter.presenter = FeedPresenter(
			feedView: FeedViewAdapter(
				controller: feedController,
				imageLoader: imageLoader,
				navigationAdapter: navigationAdapter),
			loadingView: WeakRefVirtualProxy(feedController),
			errorView: WeakRefVirtualProxy(feedController))
		
		return feedController
	}
	
	private static func makeFeedViewController(delegate: FeedViewControllerDelegate, title: String) -> FeedViewController {
		let bundle = Bundle(for: FeedViewController.self)
		let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
		let feedController = storyboard.instantiateInitialViewController() as! FeedViewController
		feedController.delegate = delegate
		feedController.title = title
		return feedController
	}
}


public func addTopController(viewController topViewController: UIViewController, height: CGFloat) -> (UIViewController) -> UIViewController {
	return { decorateeViewController in
		let containerViewController = UIViewController()
		
		containerViewController.addChild(topViewController)
		containerViewController.addChild(decorateeViewController)
		
		guard let containerView = containerViewController.view,
					let bannerView = topViewController.view,
					let decoratedView = decorateeViewController.view
		else { return decorateeViewController }
		
		let stackView = UIStackView()
		
		stackView.axis = .vertical
		stackView.distribution = .fill
		
		containerView.addSubview(stackView)
		
		// translatesAutoresizingMaskIntoConstraints
		stackView.translatesAutoresizingMaskIntoConstraints = false
		bannerView.translatesAutoresizingMaskIntoConstraints = false
		decoratedView.translatesAutoresizingMaskIntoConstraints = false
		
		stackView.addArrangedSubview(bannerView)
		stackView.addArrangedSubview(decoratedView)
				
		NSLayoutConstraint.activate([
			bannerView.heightAnchor.constraint(equalToConstant: height),
			bannerView.widthAnchor.constraint(equalTo: containerView.widthAnchor)
		])
		
		NSLayoutConstraint.activate([
			containerView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
			containerView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
			containerView.topAnchor.constraint(equalTo: stackView.topAnchor),
			containerView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor)
		])
		
		
		containerViewController.title = decorateeViewController.title
		
		return containerViewController
	}
	
}
