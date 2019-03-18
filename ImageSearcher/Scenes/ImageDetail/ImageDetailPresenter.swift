//
//  ImageDetailPresenter.swift
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

protocol ImageDetailPresentationLogic {
    func presentImageDetail(viewModel: SearchImage.ViewModel)
}

class ImageDetailPresenter: ImageDetailPresentationLogic {
    weak var viewController: ImageDetailDisplayLogic?

    // MARK: Do something

    func presentImageDetail(viewModel: SearchImage.ViewModel) {
        viewController?.displayImageDetail(viewModel: viewModel)
    }
}
