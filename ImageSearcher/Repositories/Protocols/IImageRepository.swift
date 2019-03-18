//
//  IImageRepository.swift
//  ImageSearcher
//
//  Created by Juliana Loaiza Labrador on 3/17/19.
//  Copyright © 2019 Juliana Loaiza Labrador. All rights reserved.
//

import Foundation


protocol IImagesRepository {

    func getImages(searchInput: SearchImage.Request, completionHandler: @escaping ([SearchImage.Response]?, NSError?) -> Void)
}
