//
//  RealmRepository.swift
//  naverShoppingList
//
//  Created by 염성필 on 2023/09/09.
//

import UIKit
import RealmSwift

class RealmRepository {
    
    let realm = try! Realm()
    
    // 데이터 저장하기
    func creatItem(item: Item) {
        
        let task = LocalRealmDB(
            id: Int(item.productID)!,
            imageurl: item.image,
            malName: item.mallName,
            title: item.title.encodingText(),
            price: item.lprice.numberToThreeCommaString(),
            isLike: item.isLike
        )
        do {
            try realm.write {
                realm.add(task)
            }
        } catch {
            print(error)
        }
    }
    
    // 데이터 불러오기
    func fetch() -> Results<LocalRealmDB> {
        let savedData = realm.objects(LocalRealmDB.self)
        return savedData
    }
    
    // 데이터 삭제하기
    func deleData(item: LocalRealmDB) {
        do {
            try realm.write {
                realm.delete(item)
            }
        } catch {
            
        }
    }
    
}
