//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import Combine
import Foundation
import EssentialFeed
import EssentialFeediOS

final class FeedImageDataLoaderPresentationAdapter<View: FeedImageView, Image>: FeedImageCellControllerDelegate where View.Image == Image {
	private let model: FeedImage
	private let imageLoader: (URL) -> FeedImageDataLoader.Publisher
	private var cancellable: Cancellable?
	private var feedNavigationAdapter: FeedNavigationAdapter
	
	var presenter: FeedImagePresenter<View, Image>?
	
	init(model: FeedImage, imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher, feedNavigationAdapter: FeedNavigationAdapter) {
		self.model = model
		self.imageLoader = imageLoader
		self.feedNavigationAdapter = feedNavigationAdapter
	}
	
	func didRequestImage() {
		presenter?.didStartLoadingImageData(for: model)
		
		let model = self.model
		
		cancellable = imageLoader(model.url)
			.dispatchOnMainQueue()
			.sink(
				receiveCompletion: { [weak self] completion in
					switch completion {
					case .finished: break
						
					case let .failure(error):
						self?.presenter?.didFinishLoadingImageData(with: error, for: model)
					}
					
				}, receiveValue: { [weak self] data in
					self?.presenter?.didFinishLoadingImageData(with: data, for: model)
				})
	}
	
	func didCancelImageRequest() {
		cancellable?.cancel()
	}
	
	func didSelectImage() {
		feedNavigationAdapter.showComments(for: model.id)
	}
	
}

public protocol FeedNavigationAdapter {
	func showComments(for imageId: UUID)
}
