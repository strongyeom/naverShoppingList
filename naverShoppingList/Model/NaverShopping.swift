//
//  NaverShopping.swift
//  naverShoppingList
//
//  Created by 염성필 on 2023/09/07.
//

import Foundation

// MARK: - NaverShopping
struct NaverShopping: Codable {
    let total, start, display: Int
    var items: [Item]
}

// MARK: - Item
struct Item: Codable {
    let title: String
    let image: String
    let lprice, mallName, productID: String
    var isLike: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case title, image, lprice, mallName
        case productID = "productId"
    }
}
