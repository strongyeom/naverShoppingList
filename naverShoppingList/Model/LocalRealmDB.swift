//
//  RealmModel.swift
//  naverShoppingList
//
//  Created by 염성필 on 2023/09/08.
//

import Foundation
import RealmSwift

class LocalRealmDB: Object {
    
    @Persisted(primaryKey: true) var id: String
    @Persisted var imageurl: String
    @Persisted var malName: String
    @Persisted var title: String
    @Persisted var price: String
    @Persisted var date: Date
    
    convenience init(id: String, imageurl: String, malName: String, title: String, price: String) {
        self.init()
        self.id = id
        self.imageurl = imageurl
        self.malName = malName
        self.title = title
        self.price = price
        self.date = Date()
    }
}
