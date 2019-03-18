//
//  ImageCollectionViewCell.swift
//  ImageSearcher
//
//  Created by Juliana Loaiza Labrador on 3/17/19.
//  Copyright © 2019 Juliana Loaiza Labrador. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: URLImageView!
    @IBOutlet weak var titleLabel: UILabel!

    var searchImage: SearchImage.ViewModel? {
        didSet {
            titleLabel.text = searchImage?.title
            if let imageURL = searchImage?.urlImage {
                image.downloadedFrom(urlString: imageURL)
            }
        }
    }
}
