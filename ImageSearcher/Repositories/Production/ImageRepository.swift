//
//  ImageRepository.swift
//  ImageSearcher
//
//  Created by Juliana Loaiza Labrador on 3/17/19.
//  Copyright © 2019 Juliana Loaiza Labrador. All rights reserved.
//

import Foundation
import Alamofire

class ImagesRepository: IImagesRepository {

    static let sharedInstance = ImagesRepository()

    class var sharedDispatchInstance: ImagesRepository {
        struct Static {
            static var onceToken = NSUUID().uuidString
            static var instance: ImagesRepository? = nil
        }
        DispatchQueue.once(token: Static.onceToken) {
            Static.instance = ImagesRepository()
        }
        return Static.instance!
    }

    class var sharedStructInstance: ImagesRepository {
        struct Static {
            static let instance = ImagesRepository()
        }
        return Static.instance
    }

    func getImages(searchInput: SearchImage.Request, completionHandler: @escaping ([SearchImage.Response]?, NSError?) -> Void) {

        let headers: HTTPHeaders = [
            "Authorization": "Client-ID 126701cd8332f32",
            "Content-Type": "application/json"
        ]

        Alamofire.request("\(URLsOperationServices.getImages.description)\(searchInput.indexPage)?q=\(searchInput.searchInput)&q_type=png", method: HTTPMethod.get, encoding: JSONEncoding.default, headers: headers).validate().responseJSON {
            (response:DataResponse<Any>) in
            switch(response.result) {
            case .success(_):
                if let data = response.data ,
                    let response = try? JSONDecoder().decode(SearchImage.Data.self, from: data) {
                    completionHandler(response.data, nil)
                }
                break
            case .failure(_):
                completionHandler(nil,nil)
                break
            }
        }
    }

}
