//
//  NaverViewModel.swift
//  naverShoppingList
//
//  Created by 염성필 on 2023/09/22.
//

import Foundation
import RealmSwift

class NaverViewModel {
    
    let realmRepository = RealmRepository()
    
    var naverShopping = Observable(NaverShopping(total: 0, start: 0, display: 0, items: []))
    
    //    var realmData = Observable(LocalRealmDB(id: "", imageurl: "", malName: "", title: "", price: ""))
    
    var realmType : Results<LocalRealmDB>!
    
    lazy var realmData = Observable(realmType!)
    
    
    
    func request(query: String?, start: Int, sort: ProductSort) {
        NetwokeManager.shared.callRequest(api: NetworkAPI.naverShopping(query: query, start: start, sort: sort)) { response in
            switch response {
            case .success(let success):
                print("success",success.items.count)
                self.naverShopping.value.items.append(contentsOf: success.items)
            case .failure(let failure):
                print(failure.naverErrorDescription)
            }
        }
    }
    
    func addRealm(item: Item) {
        realmRepository.creatItem(item: item)
    }
    
    // 데이터 불러오기
    func fetch(){
        realmData.value = realmRepository.fetch()
    }
}
