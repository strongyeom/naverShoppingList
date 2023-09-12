//
//  ImageCacheManager.swift
//  naverShoppingList
//
//  Created by 염성필 on 2023/09/12.
//

import UIKit

class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    
    private init() { }
}
