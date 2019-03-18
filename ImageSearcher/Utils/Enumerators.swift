//
//  Enumerators.swift
//  ImageSearcher
//
//  Created by Juliana Loaiza Labrador on 3/17/19.
//  Copyright © 2019 Juliana Loaiza Labrador. All rights reserved.
//

import Foundation

enum URLsOperationServices : CustomStringConvertible {
    case getImages

    var description: String {
        switch self {
        case .getImages:
            return "\(BASE_URI)gallery/search/time/"
        }
    }
}
