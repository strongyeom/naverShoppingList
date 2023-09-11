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
            // caseInsensitive : 대소문자 구별을 없애줌
            // $0.diaryTitle.contains("제목", options: .caseInsensitive)
            
            // 2. Bool
            // $0.diaryLike == true
            
            // 3. 사진이 있는 데이터만 불러오기 ( diaryPhoho의 nil 여부 판단 )
            $0.title.contains(text, options: .caseInsensitive)
         }
        
        return result
    }
    
    // Shopping 데이터 삭제하기
    func deleData(item: Results<LocalRealmDB>, shoppingIndex: Item) {
        do {
            
            try realm.write {
                let itemDelete = item.where{ $0.id == shoppingIndex.productID }
                realm.delete(itemDelete)
            }
        } catch {
            
        }
    }
    
    // RealMData 데이터 삭제하기
    func deleData(item: Results<LocalRealmDB>, realmIndex: LocalRealmDB) {
        do {
            
            try realm.write {
                let itemDelete = item.where{ $0.id == realmIndex.id }
                realm.delete(itemDelete)
            }
        } catch {
            
        }
    }
    
    
    
}
