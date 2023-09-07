//
//  RealmModel.swift
//  naverShoppingList
//
//  Created by 염성필 on 2023/09/08.
//

import Foundation
import RealmSwift

class RealmModel: Object {
    
    @Persisted var id: Int
    @Persisted var imageurl: String
    @Persisted var malName: String?
    @Persisted var title: String
    @Persisted var price: Int
    @Persisted var like: Bool
    
    convenience init(id: Int, imageurl: String, malName: String? = nil, title: String, price: Int) {
        self.init()
        self.id = id
        self.imageurl = imageurl
        self.malName = malName
        self.title = title
        self.price = price
        self.like = false
    }
}
