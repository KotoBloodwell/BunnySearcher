//
//  SearchImageInteractor.swift
//  ImageSearcher
//
//  Created by Juliana Loaiza Labrador on 3/17/19.
//  Copyright (c) 2019 Juliana Loaiza Labrador. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol SearchImageBusinessLogic {
    func searchImage(request: SearchImage.Request)
    func showImageDetail (viewModel: SearchImage.ViewModel)
}

protocol SearchImageDataStore {
    var imageDetail: SearchImage.ViewModel? { get set }
}

class SearchImageInteractor: SearchImageBusinessLogic, SearchImageDataStore {
    var presenter: SearchImagePresentationLogic?
    var worker: SearchImageWorker?
    var imageDetail: SearchImage.ViewModel?

    func searchImage(request: SearchImage.Request) {
        worker = SearchImageWorker()

        worker?.searchImage(searchInput: request, completionHandler: { (response, error) in
            guard let response = response else { return }
            self.presenter?.presentImages(response: response)
        })
    }

    func showImageDetail (viewModel: SearchImage.ViewModel) {
        imageDetail = viewModel
        presenter?.presentImageDetail()
    }
}
