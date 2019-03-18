//
//  SearchImageViewController.swift
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

protocol SearchImageDisplayLogic: class {
    func displayImages(viewModel: [SearchImage.ViewModel])
    func displayImageDetail()
}

class SearchImageViewController: UIViewController, SearchImageDisplayLogic {
    var interactor: SearchImageBusinessLogic?
    var router: (NSObjectProtocol & SearchImageRoutingLogic & SearchImageDataPassing)?
    var images: [SearchImage.ViewModel] = []
    var page: Int = 0
    let debouncer = Debouncer(timeInterval: 0.25)
    var imageTransition: UIImageView?
    var fetchMore: Bool = true

    @IBOutlet weak private var imagesCollectionView: UICollectionView!
    @IBOutlet weak private var searchBar: UISearchBar!
    @IBOutlet weak private var notFoundView: UIView!
    @IBOutlet weak private var notFoundText: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    // MARK: Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: Setup

    private func setup() {
        let viewController = self
        let interactor = SearchImageInteractor()
        let presenter = SearchImagePresenter()
        let router = SearchImageRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: Routing

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "🐰"
        hideLoadingIndicator()
    }

    func displayImages(viewModel: [SearchImage.ViewModel]) {
        imagesCollectionView.performBatchUpdates({
            for model in viewModel {
                let indexPath = IndexPath(item: images.count, section: 0)
                self.images.append(model)
                imagesCollectionView.insertItems(at: [indexPath])
            }
        })

        page += 1
        hideLoadingIndicator()
        notFoundView.isHidden = images.count > 0
    }

    func cleanCollection() {
        self.images = []
        notFoundView.isHidden = false
        hideLoadingIndicator()
        imagesCollectionView.reloadData()
    }

    func displayImageDetail() {
        self.performSegue(withIdentifier: "ImageDetail", sender: self)
    }

    func showLoadingIndicator() {
        loadingIndicator.isHidden = false
        notFoundView.isHidden = false
        notFoundText.text = "Loading... 🐰"
    }

    func hideLoadingIndicator() {
        fetchMore = true
        loadingIndicator.isHidden = true
        notFoundText.text = "Images not found 🐰"
    }
}

extension SearchImageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        cell.searchImage = images[indexPath.row]
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if offsetY > contentHeight - scrollView.frame.height {
            if let input = searchBar.text, fetchMore {
                fetchMore = false
                showLoadingIndicator()
                interactor?.searchImage(request: SearchImage.Request(searchInput: input, indexPage: self.page))
            }
        }
    }

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape,
            let layout = imagesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let width = view.frame.height/5 - view.safeAreaInsets.bottom
            let height = view.frame.width/2
            layout.itemSize = CGSize(width: width, height: height)
            layout.invalidateLayout()
        } else if UIDevice.current.orientation.isPortrait,
            let layout = imagesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let width = view.frame.height/3
            let height = view.frame.width/5
            layout.itemSize = CGSize(width: width, height: height)
            layout.invalidateLayout()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = imagesCollectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell, let viewModel = cell.searchImage {
            imageTransition = cell.image
            interactor?.showImageDetail(viewModel: viewModel)
        }
    }
}

extension SearchImageViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        debouncer.handler = {
            if searchText != "" {
                self.cleanCollection()
                self.showLoadingIndicator()
                self.interactor?.searchImage(request: SearchImage.Request(searchInput: searchText, indexPage: 0))
            } else {
                self.cleanCollection()
            }
            self.page = 0
        }
        debouncer.renewInterval()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}

extension SearchImageViewController: Scaling {

    func scalingImageView(transition: ScaleTransitionDelegate) -> UIImageView? {
        return imageTransition
    }
}