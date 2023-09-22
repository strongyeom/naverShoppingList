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
            id: item.productID,
            imageurl: item.image,
            malName: item.mallName,
            title: item.title.encodingText(),
            price: item.lprice.numberToThreeCommaString()
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
        let savedData = realm.objects(LocalRealmDB.self).sorted(byKeyPath: "date", ascending: false)
        return savedData
    }
    
    // 데이터 필터하기
    func fetchFilter(text: String) -> Results<LocalRealmDB> {
        let result = realm.objects(LocalRealmDB.self).where {
            $0.title.contains(text, options: .caseInsensitive)
         }
        return result
    }
    
    
    func filterId(value: Item) -> Bool {
        let result = realm.object(ofType: LocalRealmDB.self, forPrimaryKey: value.productID)
        print(result)
        if result != nil {
            RealmRepository().deleData(item: RealmRepository().fetch(), shoppingIndex: value)
            return true
        } else {
            RealmRepository().creatItem(item: value)
            return false
        }
        
    }
    
    func filterItem(value: Item) -> LocalRealmDB? {
        let result = realm.object(ofType: LocalRealmDB.self, forPrimaryKey: value.productID)
        return result
    }
    
    func filterRealm(value: LocalRealmDB) -> LocalRealmDB? {
        let result = realm.object(ofType: LocalRealmDB.self, forPrimaryKey: value.id)
        return result
    }
    
    
    
    
    // Shopping 데이터 삭제하기
    func deleData(item: Results<LocalRealmDB>, shoppingIndex: Item) {
        do {
            try realm.write {
                let itemDelete = filterItem(value: shoppingIndex)
                guard let itemDelete else { return }
                realm.delete(itemDelete)
            }
        } catch {
            print("네트워크 통신에서 받아온 데이터를 삭제하지 못했습니다 : \(error.localizedDescription)")
        }
    }
    
    // RealMData 데이터 삭제하기
    func deleData(item: Results<LocalRealmDB>, realmIndex: LocalRealmDB) {
        do {
            
            try realm.write {
                let itemDelete = filterRealm(value: realmIndex)
                guard let itemDelete else { return }
                realm.delete(itemDelete)
                
            }
        } catch {
            print("Realm에 저장된 데이터를 삭제하지 못했습니다. : \(error.localizedDescription)")
        }
    }
    
    
    
}
